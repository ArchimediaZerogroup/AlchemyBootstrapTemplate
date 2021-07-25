require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WebSite
  class Application < Rails::Application
    config.i18n.available_locales = [:it]
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.i18n.available_locales = [:it, :en]
    config.action_controller.include_all_helpers=false
    config.i18n.default_locale = :it
    config.time_zone = 'Rome'
    if Rails.application.credentials[Rails.env.to_sym] and Rails.application.credentials[Rails.env.to_sym][:default_url_options]
      config.action_mailer.default_url_options = Rails.application.credentials[Rails.env.to_sym][:default_url_options]
      config.action_mailer.asset_host = Rails.application.
        credentials[Rails.env.to_sym][:default_url_options][:protocol] + "://" +
        Rails.application.credentials[Rails.env.to_sym][:default_url_options][:host] + ":" + Rails.application.
        credentials[Rails.env.to_sym][:default_url_options][:port]
    end

    config.to_prepare do
      # Load application's model / class decorators
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    smtp_settings = Rails.application.credentials.dig(Rails.env.to_sym,:smtp_settings)
    if smtp_settings
      config.action_mailer.delivery_method = :smtp
      config.action_mailer.smtp_settings = smtp_settings
    end

  end
end
