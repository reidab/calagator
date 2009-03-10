# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '8813a7fec0bb4fbffd283a3868998eed'

  layout "application"

  # For vendor/plugins/exception_notification
  include ExceptionNotifiable

  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  # Setup theme
  layout "application"
  theme THEME_NAME # DEPENDENCY: lib/theme_reader.rb

protected

  #---[ Helpers ]---------------------------------------------------------

  # Returns a data structure used for telling the CSS menu which part of the
  # site the user is on. The structure's keys are the symbol names of resources
  # and their values are either "active" or nil.
  def link_class
    return @_link_class_cache ||= {
      :events => (( controller_name == 'events' ||
                    controller_name == 'sources' ||
                    controller_name == 'site')  && 'active'),
      :venues => (controller_name == 'venues'  && 'active'),
    }
  end
  helper_method :link_class

  def subnav_content
    name = \
      case controller_name
      when "site", "application"
        "events"
      else
        controller_name
      end
    return \
      begin
        render_to_string(:partial => "#{name}/subnav")
      rescue
        "<!-- No subnav for controller: #{name} -->"
      end
  end
  helper_method :subnav_content
end

# Make it possible to use helpers in controllers
# http://www.johnyerhot.com/2008/01/10/rails-using-helpers-in-you-controller/
class Helper
  include Singleton
  include ActionView::Helpers::UrlHelper # Provide: #link_to
end
def help
  Helper.instance
end
