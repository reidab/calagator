# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '~> 2.1.0' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Specify gems that this application depends on. 
  # They can then be installed with "rake gems:install" on new installations.
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem "htmlentities"
  config.gem "vpim"
  config.gem "lucene_query"
  # NOTE: There's an evil "has_many_polymorphs" 2.13 that's broken, and a "johnsbrn-has_many_polymorphs" 2.13.3 that that only works with Rails 2.2
  config.gem "has_many_polymorphs", :version => "2.12"
  config.gem "hpricot"
  config.gem "rubyzip", :lib =>  "zip/zip"
  config.gem 'rspec', :version => '>= 1.1.12', :lib => false
  config.gem 'rspec-rails', :version => '>= 1.1.12', :lib => false
  config.gem "facets", :version => ">=2.5.0", :lib => false


  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Comment line to use default local time.
  ### config.time_zone = 'UTC'

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with "rake db:sessions:create")
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
  config.active_record.observers = :cache_observer

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  # FIXME Figure out why ActiveRecord hasn't been told to use UTC timezone by default.

  #---[ Custom ]----------------------------------------------------------

  config.load_paths += %W[
    #{RAILS_ROOT}/app/mixins
    #{RAILS_ROOT}/app/observers
  ]

  cache_path = "#{RAILS_ROOT}/tmp/cache/#{RAILS_ENV}"
  config.cache_store = :file_store, cache_path
  FileUtils.mkdir_p(cache_path)
  
  #---[ Custom libraries ]------------------------------------------------

  # Load custom libraries before "config/initializers" run.
  $LOAD_PATH.unshift("#{RAILS_ROOT}/lib")

  # Read secrets
  require 'secrets_reader'
  SECRETS = SecretsReader.read

  # Read theme
  require 'theme_reader'
  THEME_NAME = ThemeReader.read
  Kernel.class_eval do
    def theme_file(filename)
      return "#{RAILS_ROOT}/themes/#{THEME_NAME}/#{filename}"
    end
  end

  # Read settings
  require 'settings_reader'
  SETTINGS = SettingsReader.read(
    theme_file("settings.yml"), {
      'timezone'                 => 'Pacific Time (US & Canada)',
    }
  )

  # Set timezone
  config.time_zone = SETTINGS.timezone

  # Set cookie session
  config.action_controller.session = {
    :session_key => SECRETS.session_name || "calagator",
    :secret => SECRETS.session_secret,
  }
end

# NOTE: See config/initializers/ directory for additional code loaded at start-up
