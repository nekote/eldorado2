# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true
config.log_level = :error

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# Use a different cache store in production
# config.cache_store = :mem_cache_store
# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

###
### Let's give ActiveRecord a shot (table sessions)
### as opposed to the default standard of :cookie_cache_store
### or the alternative :mem_cache_store
###
###config.action_controller.session_store = :active_record_store
###

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

config.after_initialize do
  require 'application' unless Object.const_defined?(:ApplicationController)
  LoggedExceptionsController.class_eval do
    session :session_key => '_eldorado_session_id'
    self.application_name = "El Dorado"
    include AuthenticationSystem
    before_filter :require_admin
  end
end
