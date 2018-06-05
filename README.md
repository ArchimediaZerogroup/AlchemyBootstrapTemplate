# Bootrap Alchemy Template #
                           
This template is used for create project that use [AlchemyCMS](https://github.com/AlchemyCMS/alchemy_cms) as CMS.
The template install Alchemy, other gems and other "snippets" that [Archimedia](https://www.archimedianet.it) often use into it's projects. 


## Requirements ##
This template require:
  
* Ruby on Rails 5.2.x

## Use ##

New project

```
DISABLE_SPRING=true rails _5.1.4_ new blog -m https://raw.githubusercontent.com/ArchimediaZerogroup/AlchemyBootstrapTemplate/master/template.rb

```

Use the template into existing project:

```
DISABLE_SPRING=true bin/rails app:template LOCATION=https://raw.githubusercontent.com/ArchimediaZerogroup/AlchemyBootstrapTemplate/master/template.rb

```

## What the template do? ##
1. Generate new Rails application
2. Include Jquery
3. Configure assets/javascript
4. Configure assets/css
5. Install required components
6. Install AlchemyCMS
7. Configure AlchemyCMS
8. Configure Docker Stack e Capistrano per deploy 


## Included gems ##
This is the gems that you can install with template:
 
* [Alchemy CMS](https://alchemy-cms.com/)
* [Alchemy Devise](https://github.com/AlchemyCMS/alchemy-devise)
* [Bourbon](http://bourbon.io/)
* [Owlcarousel2](https://github.com/git-jls/owlcarousel2-rails)
* [Bootstrap(4)](https://github.com/twbs/bootstrap-rubygem)
* [Font awesome](https://github.com/bokmann/font-awesome-rails)
* [Cookie Law](https://github.com/coders51/cookie_law)
* [Re-Captcha](http://github.com/ambethia/recaptcha)
* [Airbrake](https://airbrake.io/)
* [Capistrano](http://capistranorb.com/)
* [Stackose](https://github.com/oniram88/stackose)
* [PG Search](https://github.com/Casecommons/pg_search)
* [Friendly Id](https://github.com/norman/friendly_id) 
* [rails-i18n](http://github.com/svenfuchs/rails-i18n)
* [redis-rack-cache](https://rubygems.org/gems/redis-rack-cache)
* [redis-rails](https://github.com/redis-store/redis-rails)


## Included code snippets ##
This is the snippets that you can install with template:
 
### Fail 2 ban ###
 [Fail 2 Ban](https://www.fail2ban.org/wiki/index.php/Main_Page) 

``` 
 config/initializers/fail2ban.rb
```
 
### Language link url ###

```
app/helpers/link_languages_helper_decorator.rb
  
<%= language_links_by_page(@page) %> 
```  
  
### Contact Form / Newsletter form registration ###
Models, Mailer, Controller, View for implement contacts form site and contact registration newsletter 

From LINE:
https://github.com/ArchimediaZerogroup/AlchemyBootstrapTemplate/blob/ca50e4b115948dff18626cc79101e4b7b7598a45/template.rb#L560

To LINE:
https://github.com/ArchimediaZerogroup/AlchemyBootstrapTemplate/blob/ca50e4b115948dff18626cc79101e4b7b7598a45/template.rb#L648


## PG Search ##
If you include pg_search gem, the template generate snippets that are useful for implement  full text search into project.

From LINE:
https://github.com/ArchimediaZerogroup/AlchemyBootstrapTemplate/blob/ca50e4b115948dff18626cc79101e4b7b7598a45/template.rb#L327

To LINE:
https://github.com/ArchimediaZerogroup/AlchemyBootstrapTemplate/blob/ca50e4b115948dff18626cc79101e4b7b7598a45/template.rb#L384


## Ajax Submit Form  ##  
"Ajax submit form" snippets consist of function and views useful for implement ajax form and submit module

From LINE:
https://github.com/ArchimediaZerogroup/AlchemyBootstrapTemplate/blob/ca50e4b115948dff18626cc79101e4b7b7598a45/template.rb#L392

To LINE:
https://github.com/ArchimediaZerogroup/AlchemyBootstrapTemplate/blob/ca50e4b115948dff18626cc79101e4b7b7598a45/template.rb#L416
  
## News Module ##  
News module consist into various snippets that are examples for implement a custom model. The custom model is for "News" and "News argument" management. This examples implement  also a "proxed element" that connect to the custom model to Alchemy logics of elements. This custom model implement also friendly_id language_id and all tags for SEO managements.
  
From LINE:
https://github.com/ArchimediaZerogroup/AlchemyBootstrapTemplate/blob/ca50e4b115948dff18626cc79101e4b7b7598a45/template.rb#L418

To LINE:
https://github.com/ArchimediaZerogroup/AlchemyBootstrapTemplate/blob/ca50e4b115948dff18626cc79101e4b7b7598a45/template.rb#L555
  
                                                  
### Docker / Deploy with Docker Stack ###
Deploy implementations with Docker. Stackose gems is installed and used for Docker into production environment. 

For complete the configuration, launch the command:
`stackose:create_online_docker_compose_file` that generate file `docker-compose-{STAGE}.yml` with information for deploy.
 
Capistrano tasks:
* docker:db:push -> Upload database
* docker:db:pull -> Download database
* stackose:create_online_docker_compose_file -> Generate docker compose local file

FROM LINE
https://github.com/ArchimediaZerogroup/AlchemyBootstrapTemplate/blob/ca50e4b115948dff18626cc79101e4b7b7598a45/template.rb#L261

TO LINE
https://github.com/ArchimediaZerogroup/AlchemyBootstrapTemplate/blob/ca50e4b115948dff18626cc79101e4b7b7598a45/template.rb#L308
  
  
  
## TODO ##
* [https://github.com/presidentbeef/brakeman](https://github.com/presidentbeef/brakeman)
* [https://github.com/thredded/db_text_search](https://github.com/thredded/db_text_search)

  
