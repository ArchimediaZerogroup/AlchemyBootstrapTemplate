
ajax_form
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/controllers/ajax_forms_controller.rb
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/assets/javascripts/ajax_forms.js
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/views/ajax_forms/create.json.jbuilder
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/controllers/contact_forms_controller.rb
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/lib/contact_form_resource.rb


  

Varie
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/helpers/link_languages_helper_decorator.rb
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/config/locales/it.yml

  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/config/routes.rb
  namespace admin
    resources :advices, concerns: :switch_lang
    resources :arguments, concerns: :switch_lang
    resources :contact_forms  
  end
  
  resources :contact_forms , only: [:create]

  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/db/migrate/20180504081148_add_language_id_to_advice.rb

  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/db/migrate/20180504131126_add_description_and_title_to_advice.rb  + slug
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/db/migrate/20180504144212_add_seo_field_to_advice.rb




  
  
Searches
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/lib/search_result.rb
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/models/alchemy/content_decorator.rb
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/models/alchemy/essence_html_decorator.rb
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/models/alchemy/essence_richtext_decorator.rb
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/models/alchemy/essence_text_decorator.rb
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/models/alchemy/page_decorator.rb

  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/models/concerns/alchemy/content_dec.rb
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/models/concerns/alchemy/essence_html_dec.rb
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/models/concerns/alchemy/essence_richtext_dec.rb
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/models/concerns/alchemy/essence_text_dec.rb
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/models/concerns/alchemy/page_dec.rb

  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/models/concerns/searchable.rb
  
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/views/alchemy/search/_form.html.erb
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/views/alchemy/search/_result.html.erb
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/views/alchemy/search/_results.html.erb

  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/config/alchemy/elements.yml
  - name: search_form
  hint: false
  contents: []


  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/config/alchemy/page_layouts.yml
  - name: search_results
  searchresults: true
  unique: true

  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/config/initializers/ente_bilaterale.rb
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/config/initializers/pg_serach.rb

  Gemfile:  gem 'pg_search' #Vedi generator

  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/db/migrate/20180405200556_add_searchable_to_alchemy_essence_texts.alchemy_pg_search.rb
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/db/migrate/20180405200557_add_searchable_to_alchemy_essence_richtexts.alchemy_pg_search.rb
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/db/migrate/20180405200558_add_searchable_to_alchemy_essence_pictures.alchemy_pg_search.rb
  





custom models
  Aggiornare quanto c'è già dentro dei custom model
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/helpers/alchemy/pages_helper_decorator.rb  (escluso questo def print_news_home)  
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/controllers/admin/friendly_loader.rb
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/controllers/alchemy/pages_controller_decorator.rb
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/controllers/alchemy/resource_controller_decorator.rb
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/controllers/concerns/pages_controller_dec.rb
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/controllers/concerns/resource_controller_dec.rb
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/helpers/application_helper.rb
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/inputs/alchemy_element_input.rb  (verifica se aggiornato)
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/lib/contact_form_resource.rb

  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/config/alchemy/page_layouts.yml
  - name: not_found
    elements: [block_title,block_paragraph, block_image_in_paragraph, paragraph_with_image]

  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/db/migrate/20180406084907_add_proxed_element_id_to_element.rb
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/db/migrate/20180430091924_add_proxed_element_type_to_alchemy_element.rb








======   DONE: ======

Frielndly-id

  Gemfile: gem 'friendly_id', '~> 5.1.0' #Vedi generator



Arguments (argomenti degli advice)

  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/controllers/admin/arguments_controller.rb
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/lib/argument_resource.rb
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/models/argument.rb
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/app/models/argument_ability.rb
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/config/initializers/alchemy_argument.rb

  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/db/migrate/20180405143720_create_argument.rb
  /Users/jury/Lavori/ruby/workspaces/EnteBilaterale-alchemy/db/migrate/20180405154729_add_argument_to_advice.rb  
  
  routes.rb resources :arguments, concerns: :switch_lang (dentro admin) 
  VEdi locales
  
  
  
  