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

gem 'js-routes'
inject_into_file application_js, after: "//= require rails-ujs" do
  "\n//= require js-routes\n"
end


gem 'alchemy_cms', '~> 4.0'

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
  

end

