class AccountsController < ApplicationController
  before_filter :login_required

  def show
    redirect_to account_my_events_path
  end

end
