version = %x(bin/rails version).gsub("\n", "").gsub("Rails", "")
gem_version = Gem::Version.new(version)

puts "RICORDATI!!!! DISABLE_SPRING=true prima "


if gem_version<=Gem::Version.new("5.2")


  gem 'jquery-rails'
  gem 'jquery-ui-rails'


  application_js = 'app/assets/javascripts/application.js'
  inject_into_file application_js, before: '//= require_tree .' do
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

    inject_into_file sass_requires, before: '//= require_tree .' do
      "\n  @import \"bourbon\";\n"
    end

  end

  if yes?("Vuoi owlcarousel2?")
    gem 'owlcarousel2'
    inject_into_file sass_requires, before: '//= require_tree .' do
      "\n  @import \"owlcarousel2/owl.carousel\";\n  @import \"owlcarousel2/owl.theme.default\";\n"
    end

    inject_into_file application_js, before: '//= require_tree .' do
      "\n//= require owlcarousel2/owl.carousel\n"
    end
  end

  if yes?("Vuoi Bootstrap(4)?")
    gem 'bootstrap', '~> 4.0.0.beta3'
    inject_into_file sass_requires, before: '//= require_tree .' do
      "\n  @import \"bootstrap\";\n"
    end
    inject_into_file application_js, before: '//= require_tree .' do
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

    inject_into_file application_js, before: '//= require_tree .' do
      "\n//= require js.cookie\n//= require cookie_law\n"
    end

    inject_into_file "app/views/layouts/application.html.erb", :before => "</body>" do
      "<%= cookie_law! %>"
    end

    say "Ricordati che devi completare l'installazione configurando l'inizializzatore config/initializers/cookie_law.rb", [:red, :on_white, :bold]

    installed_cookie_law=true
  end


  if yes?("Vuoi installare l'inizializzatore per gestire i login falliti con Fail2Ban?")

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

    say "Ricordati che devi completare l'installazione configurando fail2ban, guarda in config/initializers/fail2ban.rb che c'è un esempio", [:red, :on_white, :bold]

  end

  if yes?("Vuoi installare Re-Captcha?")
    gem "recaptcha", require: "recaptcha/rails"

    file "config/initializers/recaptcha.rb", <<-CODE
Recaptcha.configure do |config|
  config.site_key  = Rails.application.secrets.recaptcha.nil? ? "" : Rails.application.secrets.recaptcha[:site_key]
  config.secret_key = Rails.application.secrets.recaptcha.nil? ? "" : Rails.application.secrets.recaptcha[:secret_key]
end
    CODE

    say "Ricordati che devi completare l'installazione configurando Re-Captcha con le API-KEY in config/initializers/recaptcha.rb", [:red, :on_white, :bold]

  end


  if yes?("Vuoi installare Airbrake?")
    gem 'airbrake', '~> 5.0'

    say "Ricordati che devi completare la configurazione", [:red, :on_white, :bold]
  end


  gem 'js-routes'
  inject_into_file application_js, before: "//= require_tree ." do
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



  if yes?("Vuoi avere la base per la form contatti e la registrazione e-mail (per newsletter?)")
    file "app/controllers/admin/user_site_registrations_controller.rb", <<-CODE
class Admin::UserSiteRegistrationsController < Alchemy::Admin::ResourcesController

  def resource_handler
    @_resource_handler ||= ::UserSiteResource.new(controller_path, alchemy_module)
  end

end
    CODE


    file "app/controllers/admin/contact_forms_controller.rb", <<-CODE
module Admin
  class ContactFormsController < UserSiteRegistrationsController

  end
end
    CODE


    file "app/controllers/admin/form_newsletters_controller.rb", <<-CODE
module Admin
  class FormNewslettersController < UserSiteRegistrationsController

  end
end
    CODE



    file "app/controllers/alchemy/base_controller_decorator.rb", <<-CODE
Alchemy::BaseController.include FormsConcern
    CODE


    file "app/controllers/concerns/forms_concern.rb", <<-CODE
require 'active_support/concern'

module FormsConcern
  extend ActiveSupport::Concern

  included do

    before_action :form_newlsetter_register
    before_action :contact_form_register


    private

    # Si occupa di ricevere i valori dell'invio della registrazione della newsletter
    def form_newlsetter_register

      if params[:form_newsletter]

        @form_newsletter = FormNewsletter.new(params.require(:form_newsletter).permit(:email, :check_privacy,:alcm_element))
        if (verify_recaptcha(model: @form_newsletter) or Rails.application.secrets.recaptcha[:simulate]) && @form_newsletter.valid?
          #registro dati, invio email
          @form_newsletter.save
          @form_newsletter.mailer.deliver

          # registro il successo dell'esecuzione
          @form_newsletter.sended!
        end

      end

    end

    def contact_form_register

      if params[:contact_form]

        @form_contatti = ContactForm.new(params.require(:contact_form).permit(
          :email,
          :check_privacy,
          :first_name,
          :last_name,
          :address,
          :city,
          :telephone,
          :message,
          :alcm_element
        ))
        if (verify_recaptcha(model: @form_contatti) or Rails.application.secrets.recaptcha[:simulate]) && @form_contatti.valid?
          #registro dati, invio email
          @form_contatti.save
          @form_contatti.mailer.deliver

          # registro il successo dell'esecuzione
          @form_contatti.sended!
        end

      end
    end
  end
end

    CODE



    file "app/lib/user_site_resource.rb", <<-CODE
class UserSiteResource < Alchemy::Resource

  def attributes
    (super + model.stored_attributes[:serialized_data].collect{|col|
      {
        name: col,
        type: :string
      }
    }).reject{|c|  [:serialized_data,:type,:check_privacy].include?(c[:name].to_sym) }
  end

  def searchable_attribute_names
    [:email]
  end

end
    CODE



    file "app/mailers/user_data_registration_mailer.rb", <<-CODE
class UserDataRegistrationMailer < ApplicationMailer


  def notify_registration(r)
    @rec = r
    mail(to: r.emails_recipient, subject: 'Nuova registrazione Sito')
  end

end

    CODE

    file "app/models/contact_form.rb", <<-CODE
class ContactForm < UserSiteRegistration
  store :serialized_data, accessors: [
    :check_privacy,
    :first_name,
    :last_name,
    :address,
    :city,
    :telephone,
    :message
  ], coder: JSON

  attribute :first_name, :string
  attribute :last_name, :string
  attribute :address, :string
  attribute :city, :string
  attribute :telephone, :string
  attribute :message, :string
  attribute :check_privacy, :boolean

  validates :first_name,
            :last_name,
            :message,
            :presence => { allow_blank: false }

  validates :check_privacy, inclusion: [true, '1']

end
    CODE

    file "app/models/form_newsletter.rb", <<-CODE
class FormNewsletter < UserSiteRegistration
  store :serialized_data, accessors: [:check_privacy], coder: JSON

  attribute :check_privacy, :boolean

  validates :check_privacy, inclusion: [true, '1']
end
    CODE


    file "app/models/user_site_registration.rb", <<-CODE
class UserSiteRegistration < ApplicationRecord

  def sended!
    @_sended = true
  end

  def sended?
    @_sended === true
  end

  validates :email, :presence => {allow_blank: false}
  validates_format_of :email, :with => /\\A([-a-z0-9!\\#$%&'*+\\/=?^_`{|}~]+\\.)*[-a-z0-9!\\#$%&'*+\\/=?^_`{|}~]+@((?:[-a-z0-9]+\\.)+[a-z]{2,})\\Z/i

  #Mi serve per memorizzare l'elemento alchemy da cui è partita la form, in modo da poter idetificare la mail del destinatario
  attr_accessor :alcm_element

  def mailer
    UserDataRegistrationMailer.notify_registration(self)
  end

  def emails_recipient
    element = Alchemy::Element.find(self.alcm_element)
    element.content_by_name(:email_destinatario_notifica).essence.body
  rescue
    ""
  end
end
    CODE

    file "app/models/user_site_registration_ability.rb", <<-CODE
class UserSiteRegistrationAbility
  include CanCan::Ability

  def initialize(user)

    if user.present? && user.is_admin?
      # can :manage, ::UserSiteRegistration
      # can :manage, :admin_user_site_registrations

      [
        [::FormNewsletter, :admin_form_newsletters],
        [::ContactForm, :admin_contact_forms]
      ].each do |objs|
        objs.each do |o|
          can :manage, o
          cannot :create, o
          cannot :update, o
        end
      end
    end
  end
end
    CODE



    file "app/views/alchemy/elements/_form_contatti_editor.html.erb", <<-CODE
<%= element_editor_for(element) do |el| -%>
  <%= el.edit :email_destinatario_notifica %>
<%- end -%>
    CODE

    file "app/views/alchemy/elements/_form_contatti_view.html.erb", <<-CODE
<%- cache(element) do -%>
  <%= element_view_for(element) do |el| -%>


    <%
      pagina_privacy = element.content_by_name(:pagina_privacy).essence
      #
      # Composta da questi elementi
      # pagina_privacy =  body: "Iscriviti",
      #                   link: nil,
      #                   link_title: nil,
      #                   link_class_name: nil,
      #                   link_target: nil
      #
    %>


    <%-
      @form_contatti = @form_contatti || ContactForm.new
      @form_contatti.alcm_element = element.id

    %>


    <% if @form_contatti.sended? %>
      <div class="messaggio_invio successo">Invio avvenuto con successo</div>
    <% else %>

      <%
        # TODO completare la questione di come renderizzare gli errori nel caso ci fossero
        unless @form_contatti.errors.empty?
      %>
        <div class="messaggio_invio errore">Errore nella compilazione del form</div>
        <%#= @form_contatti.errors.inspect %>
      <% end %>
      <div class="container">
        <div class="form_contatti_pagina">
          <%= form_for(@form_contatti, url: "?" + request.query_string + element_dom_id(element), method: 'post') do |f| %>

            <%= hidden_field_tag :_method, 'get' %>
            <%= f.hidden_field :alcm_element %>

            <div class="row">
              <div class="box_contatti col-xs-12 col-sm-6">
                <%= f.text_field :first_name, placeholder: f.object.class.human_attribute_name(:first_name) + "*", required: 'required' %>
              </div>
              <div class="box_contatti col-xs-12 col-sm-6">
                <%= f.text_field :last_name, placeholder: f.object.class.human_attribute_name(:last_name) + "*", required: 'required' %>
              </div>
              <div class="box_contatti col-xs-12 col-sm-6">
                <%= f.text_field :city, placeholder: f.object.class.human_attribute_name(:city) %>
              </div>
              <div class="box_contatti col-xs-12 col-sm-6">
                <%= f.text_field :address, placeholder: f.object.class.human_attribute_name(:address) %>
              </div>
              <div class="box_contatti col-xs-12 col-sm-6">
                <%= f.text_field :email, placeholder: f.object.class.human_attribute_name(:email) + "*", required: 'required' %>
              </div>
              <div class="box_contatti col-xs-12 col-sm-6">
                <%= f.telephone_field :telephone, placeholder: f.object.class.human_attribute_name(:telephone) %>
              </div>
              <div class="box_contatti col-xs-12 col-sm-12">
                <%= f.text_area :message, placeholder: f.object.class.human_attribute_name(:message) + "*", required: 'required' %>
              </div>
            </div>
            <div class="trattamento">
              <div class="single_trattamento"><%= f.check_box :check_privacy, required: 'required' %>
                <label>Accosenti al trattamento dei tuoi dati in base al D.Lgs 30/06/2003 n.196</label></div>
            </div>
            <div class="invia">
              <%= f.submit 'Contattaci', class: "invisible_recaptcha" %>
            </div>

          <% end %>
        </div>
      </div>
    <% end %>



  <%- end -%>
<%- end -%>
    CODE

    file "app/views/alchemy/elements/_form_iscrizione_newsletter_editor.html.erb", <<-CODE
<%= element_editor_for(element) do |el| -%>
  <%= el.edit :title %>
  <%= el.edit :bottone %>
  <%= el.edit :email_destinatario_notifica %>
  <%= el.edit :pagina_privacy %>
<%- end -%>

    CODE

    file "app/views/alchemy/elements/_form_iscrizione_newsletter_view.html.erb", <<-CODE
<%- cache(element) do -%>
  <%= element_view_for(element) do |el| -%>

    <%
      testo_bottone = element.content_by_name(:bottone).essence.body
      pagina_privacy = element.content_by_name(:pagina_privacy).essence
      #
      # Composta da questi elementi
      # pagina_privacy =  body: "Iscriviti",
      #                   link: nil,
      #                   link_title: nil,
      #                   link_class_name: nil,
      #                   link_target: nil
      #
    %>

    <div class="title">
      <%= el.render :title %>
    </div>
    <div class="pagina_privacy">
      <%#= el.render :pagina_privacy %>
    </div>

    <%-
      @form_newsletter = @form_newsletter || FormNewsletter.new
      @form_newsletter.alcm_element = element.id
    %>

    <% if @form_newsletter.sended? %>
      <div class="messaggio_invio successo">Invio avvenuto con successo</div>
    <% else %>

      <%
        # TODO completare la questione di come renderizzare gli errori nel caso ci fossero
        unless @form_newsletter.errors.empty?
      %>
        <div class="messaggio_invio errore">Errori nella compilazione del form</div>
        <%#= @form_newsletter.errors.inspect %>
      <% end %>

      <%= form_for(@form_newsletter, url: "?" + request.query_string + element_dom_id(element)", method: 'post') do |f| %>

        <%= hidden_field_tag :_method, 'get' %>
        <%= f.hidden_field :alcm_element %>
        <div class="input_newsletter">
          <%= f.email_field :email, placeholder: 'Email', required: true %>
          <%= f.submit testo_bottone, class: "invisible_recaptcha" %>
        </div>
        <%#= @form_newsletter.errors.full_messages_for(:email) %>
        <div class="trattamento">
          <%= f.check_box :check_privacy, required: true %>
          <label>ho letto e compreso l’informativa sulla privacy</label>
        </div>

      <% end %>
    <% end %>

  <%- end -%>
<%- end -%>
    CODE

    file "app/views/user_data_registration_mailer/_contact_form.html.erb", <<-CODE
<h1>Nuova contatto dal sito</h1>

Email: <%= rec.email %>
<br>
first_name: <%= rec.first_name %>
<br>
last_name: <%= rec.last_name %>
<br>
address: <%= rec.address %>
<br>
city: <%= rec.city %>
<br>
telephone: <%= rec.telephone %>
<br>
message: <%= rec.message %>

    CODE

    file "app/views/user_data_registration_mailer/_form_newsletter.html", <<-CODE
<h1>Nuova registrazione al sito per ricezione newsletter</h1>

Email: <%= rec.email %>
    CODE

    file "app/views/user_data_registration_mailer/notify_registration.html.erb", <<-CODE
<%= render partial: @rec.class.name.underscore, locals: { rec: @rec } %>
    CODE

    append_to_file "config/alchemy/elements.yml", <<-CODE
- name: form_iscrizione_newsletter
  hint: "Form per l'iscrizione della newsletter"
  unique: true
  contents:
    - name: title
      type: EssenceText
      default: 'Resta Aggiornato sulle nostre novita'
    - name: bottone
      type: EssenceText
      default: "Iscriviti"
    - name: email_destinatario_notifica
      type: EssenceText
      default: "info@example.com"
    - name: pagina_privacy
      type: EssenceText
      settings:
        linkable: true

- name: form_contatti
  hint: "Form dei contatti per il sito"
  unique: true
  contents:
    - name: pagina_privacy
      type: EssenceText
      settings:
        linkable: true
    - name: email_destinatario_notifica
      type: EssenceText
      default: "info@example.com"

    CODE

    file "config/initializers/alchemy_user_site_registrations.rb", <<-CODE
Alchemy::Modules.register_module({
                                   name: 'user_site_registrations',
                                   order: 1,
                                   navigation: {
                                     name: 'modules.form_newsletter',
                                     controller: '/admin/form_newsletters',
                                     action: 'index',
                                     image: 'alchemy/user_site_registrations_module.png',
                                     sub_navigation: [{
                                                        name: 'modules.form_newsletter',
                                                        controller: '/admin/form_newsletters',
                                                        action: 'index'
                                                      },
                                                      {
                                                        name: 'modules.contact_form',
                                                        controller: '/admin/contact_forms',
                                                        action: 'index'
                                                      }
                                                      ]
                                   }
                                 })

Alchemy.register_ability(UserSiteRegistrationAbility)
    CODE

    inject_into_file "config/routes.rb", before: 'mount Alchemy::Engine'  do
<<-CODE
namespace :admin do
    resources :user_site_registrations
    resources :form_newsletters
    resources :contact_forms
end
CODE
end

    file "db/migrate/20180102112803_create_user_site_registrations.rb", <<-CODE
class CreateUserSiteRegistrations < ActiveRecord::Migration[5.1]
  def change
    create_table :user_site_registrations do |t|
      t.string :email
      t.string :type
      t.text :serialized_data

      t.timestamps
    end
  end
end
    CODE
    rails_command 'db:migrate'

  end




  end
else
  raise "Alchemy 4.0 è compatibile con Rails <=5.1"
end
