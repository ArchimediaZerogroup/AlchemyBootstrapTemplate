#Bootrap Alchemy Template#

Questo è il template applicativo che utilizziamo per creare i progetti relativamente allo sviluppo di siti web.
Utilizziamo come CMS [AlchemyCMS](https://github.com/AlchemyCMS/alchemy_cms) ed una serie di altri componenti utili per l'implementazione.

##Requisiti##
Questo template necessita di:

* Ruby on Rails 5.1.x

##Utilizzo##

Nuovo progetto

```
DISABLE_SPRING=true rails _5.1.4_ new blog -m https://raw.githubusercontent.com/ArchimediaZerogroup/AlchemyBootstrapTemplate/master/template.rb

```

Applicare il template su un progetto già esistente

```
DISABLE_SPRING=true bin/rails app:template LOCATION=https://raw.githubusercontent.com/ArchimediaZerogroup/AlchemyBootstrapTemplate/master/template.rb

```

##Cosa fa il template?##
1. Genera una nuova applicazione Rails
2. Include Jquery
3. Configura assets/javascript
4. Configura assets/css
5. Installa i componenti richiesti
6. Installa AlchemyCMS
7. Configura AlchemyCMS


## Gemme incluse ##
Le gemme che vegono incluse, previa conferma da parte dell'utente sono:
 
* [Alchemy CMS](https://alchemy-cms.com/) e Alchemy Devise
* [Bourbon](http://bourbon.io/)
* [Owlcarousel2](https://github.com/git-jls/owlcarousel2-rails)
* [Bootstrap(4)](https://github.com/twbs/bootstrap-rubygem)
* [Font awesome](https://github.com/bokmann/font-awesome-rails)
* [Cookie Law](https://github.com/coders51/cookie_law)
* [Re-Captcha](http://github.com/ambethia/recaptcha)
* [Airbrake](https://airbrake.io/)
* [Capistrano](http://capistranorb.com/)

## Funzioni incluse ##
Le funzioni autogenerate, previa comferma da parte dell'utente sono:
### Fail 2 ban ###
 [Fail 2 Ban](https://www.fail2ban.org/wiki/index.php/Main_Page) E' un software pensato per leggere i file di log, ed attraverso il matching di regular expression, permette di "bannare"
 a livello di rete, certi indirizzi IP che tentano (per esempio) brute force od altro. L'integrazione avviene attraveso un inizializzatore specifico dove viene anche inclusa la parte di 
 configurazione per Fail2Ban
 
### Link url per lingua###
 Helper per la generazione di link languages per page. L'helper deve poi essere aggiunto al layout applicativo per l'utilizzo
  
### Form contatti / Form registrazione newsletter ###
 Modelli, Mailer, Controller, Viste per la gestione di form di contatti dal sito e form di registrazione alla newsletter 