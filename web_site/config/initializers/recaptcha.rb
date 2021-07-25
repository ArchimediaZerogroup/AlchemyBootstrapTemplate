Recaptcha.configure do |config|
  config.site_key  = Rails.application.credentials.recaptcha.nil? ? "" : Rails.application.credentials.recaptcha[:site_key]
  config.secret_key = Rails.application.credentials.recaptcha.nil? ? "" : Rails.application.credentials.recaptcha[:secret_key]
  config.skip_verify_env += ["development"]
end