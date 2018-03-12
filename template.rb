gem 'jquery-rails'
gem 'jquery-ui-rails'
application_js = 'app/assets/javascripts/application.js'
inject_into_file application_js, before: '//' do
  "\n//= require jquery3\n//= require jquery_ujs\n//= require jquery-ui\n"
end

application_css = 'app/assets/stylesheets/application.css'
inject_into_file application_css, :before => " */" do
  "\n  *= require sass_requires\n"
end

sass_requires = 'app/assets/stylesheets/sass_requires.scss'

file sass_requires, <<-CODE
//
CODE

if yes?("Vuoi Bourbon?(fratello di compass)")
  gem 'bourbon'

  inject_into_file sass_requires, before: '//' do
    "\n  @import \"bourbon\";\n"
  end

end

if yes?("Vuoi owlcarousel2?")
  gem 'owlcarousel2'
  inject_into_file sass_requires, before: '//' do
    "\n  @import \"owlcarousel2/owl.carousel\";\n  @import \"owlcarousel2/owl.theme.default\";\n"
  end

  inject_into_file application_js, before: '//' do
    "\n//= require owlcarousel2/owl.carousel\n"
  end
end

if yes?("Vuoi Bootstrap(4)?")
  gem 'bootstrap', '~> 4.0.0.beta3'
  inject_into_file sass_requires, before: '//' do
    "\n  @import \"bootstrap\";\n"
  end
  inject_into_file application_js, before: '//' do
    "\n//= require popper\n//= require bootstrap\n"
  end

end

if yes?("Vuoi le icone di font awesome?")
  gem "font-awesome-rails"

  inject_into_file application_css, :before => " */" do
    "\n  *= require font-awesome\n"
  end

end


installed_cookie_law=false
if yes?("Vuoi la gemma per cookie law ?")
  gem "cookie_law"

  inject_into_file application_css, :before => " */" do
    "\n  *= require cookie_law\n"
  end

  inject_into_file application_js, before: '//' do
    "\n//= require js.cookie\n//= require cookie_law\n"
  end

  inject_into_file "app/views/layouts/application.html.erb", :before => "</body>" do
    "<%= cookie_law! %>"
  end

  say "Ricordati che devi completare l'installazione configurando l'inizializzatore config/initializers/cookie_law.rb"

  installed_cookie_law=true
end


if yes?("Vuoi installare l'inizializzatore per gestire i login falliti con Fail2Ban")

  file "config/initializers/fail2ban.rb", <<-CODE
module Fail2ban

  LOGGER = Logger.new(Rails.root.join('log', 'logins.log'), 'weekly')

  ATTEMPT_PATHS = ["/admin/login",
                   "/users/sign_in"]

  Warden::Manager.before_failure do |env, opts|
    if opts[:action] == 'unauthenticated' and Fail2ban::ATTEMPT_PATHS.include?(opts[:attempted_path])
      ip = env['action_dispatch.remote_ip'] || env['REMOTE_ADDR']
      user = env['action_dispatch.request.parameters']['user']['email'] rescue 'unknown'

      Fail2ban::LOGGER.error "Failed login for '" + user + "' from " + ip + " at " + Time.now.utc.iso8601
    end
  end


### Fail2Ban config
## /etc/fail2ban/filter.d/your-rails-app.conf

#[INCLUDES]
#before = common.conf
#[Definition]
#failregex = ^\s*(\[.+?\] )*Failed login for '.*' from <HOST> at $


##/etc/fail2ban/jail.local

#[your-rails-app]
#enabled = true
#filter  = your-rails-app
#port    = http,https
#logpath = /path/to/your/production.log

end

CODE


end


gem 'js-routes'
inject_into_file application_js, after: "//= require rails-ujs" do
  "\n//= require js-routes\n"
end


gem 'alchemy_cms', '~> 4.0'
gem 'alchemy-devise', '~> 4.0'


capistrano_installed = false
if yes?("Vuoi installare capistrano per il deploy?")

  capistrano_installed = true
  gem_group :development do
    gem 'capistrano'
    gem 'capistrano-rails'
    gem 'capistrano-rvm'
    gem 'capistrano-rails-console', '~> 1.0.0'
    gem 'capistrano-rails-tail-log'
    gem 'capistrano-db-tasks', require: false
    gem 'capistrano-passenger'
  end

end


lang = ask('Definisci la lingua di default[it]')
lang = 'it' if lang.blank?

timezone = ask('Definisci Timezone[Rome]')
timezone = 'Rome' if timezone.blank?

file 'config/initializers/base_setup.rb', <<-CODE
Rails.application.config.time_zone = '#{timezone}'
Rails.application.config.i18n.default_locale = :#{lang}

Rails.application.config.action_mailer.delivery_method = :smtp
Rails.application.config.action_mailer.smtp_settings = Rails.application.secrets.smtp
CODE


after_bundle do

  run "bundle exec cap install"
  inject_into_file 'Capfile', :before => "# Load custom " do
    "\nrequire 'capistrano/rvm'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/passenger'
require 'capistrano-db-tasks'\n\n"
  end

  rails_command 'alchemy:install'
  generate 'alchemy:devise:install'

  generate 'cookie_law:install' if installed_cookie_law

end

