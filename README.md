# Bootrap Alchemy Template #
                           
This template is used for create project that use [AlchemyCMS](https://github.com/AlchemyCMS/alchemy_cms) as CMS.
The template install Alchemy, other gems and other "snippets" that [Archimedia](https://www.archimedianet.it) often use into it's projects. 


## Requirements ##
This template require:
  
* Ruby on Rails > 5.2.3 

## Use ##

New project

```
DISABLE_SPRING=true rails _5.2.3_ new blog -m https://raw.githubusercontent.com/ArchimediaZerogroup/AlchemyBootstrapTemplate/master/template.rb

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
8. Configure Docker Stack e Capistrano for deploy 


## Included gems ##
This is the gems that you can install with template:
 
* [Alchemy CMS](https://alchemy-cms.com/)
* [Alchemy Devise](https://github.com/AlchemyCMS/alchemy-devise)
* [tiny-slider](https://github.com/ganlanyuan/tiny-slider)
* [Bootstrap(4)](https://github.com/twbs/bootstrap-rubygem)
* [Font awesome](https://github.com/bokmann/font-awesome-rails)
* [Cookie Law](https://github.com/coders51/cookie_law)
* [Re-Captcha](http://github.com/ambethia/recaptcha)
* [Capistrano](http://capistranorb.com/)
* [Stackose](https://github.com/oniram88/stackose)
* [PG Search](https://github.com/Casecommons/pg_search)
* [Friendly Id](https://github.com/norman/friendly_id) 
* [rails-i18n](http://github.com/svenfuchs/rails-i18n)
* [redis-rack-cache](https://rubygems.org/gems/redis-rack-cache)
* [redis-rails](https://github.com/redis-store/redis-rails)
* [alchemy_custom_model](https://github.com/ArchimediaZerogroup/alchemy-custom-model)
* [alchemy-ajax-form](https://github.com/ArchimediaZerogroup/alchemy-ajax-form)



  
## TODO ##
* [https://github.com/presidentbeef/brakeman](https://github.com/presidentbeef/brakeman)
* [https://github.com/thredded/db_text_search](https://github.com/thredded/db_text_search)

  
