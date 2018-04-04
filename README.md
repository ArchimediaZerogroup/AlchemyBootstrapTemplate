# Bootrap Alchemy Template #
                           
Questo è il template applicativo che utilizziamo per creare i progetti relativamente allo sviluppo di siti web.
Utilizziamo come CMS [AlchemyCMS](https://github.com/AlchemyCMS/alchemy_cms) ed una serie di altri componenti utili per l'implementazione.

## Requisiti ##
Questo template necessita di:

* Ruby on Rails 5.1.x

## Utilizzo ##

Nuovo progetto

```
DISABLE_SPRING=true rails _5.1.4_ new blog -m https://raw.githubusercontent.com/ArchimediaZerogroup/AlchemyBootstrapTemplate/master/template.rb

```

Applicare il template su un progetto già esistente

```
DISABLE_SPRING=true bin/rails app:template LOCATION=https://raw.githubusercontent.com/ArchimediaZerogroup/AlchemyBootstrapTemplate/master/template.rb

```

## Cosa fa il template? ##
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
 
### Link url per lingua ###
 Helper per la generazione di link languages per page. L'helper deve poi essere aggiunto al layout applicativo per l'utilizzo
  
### Form contatti / Form registrazione newsletter ###
 Modelli, Mailer, Controller, Viste per la gestione di form di contatti dal sito e form di registrazione alla newsletter
  
### Docker / Deploy con Docker ###
 Predispone il deploy attraverso Docker. Viene installalo capose (gemma per eseguire docker-compose online).
 Impostate le cartelle degli assets per la sincronizzazione fra sviluppo e online, tenendo conto di sincronizzare 
 con la shared.
 
 Per poter avere il sistema completo per il deploy sarà necessario prima lanciare il task 
 `docker:create_online_docker_compose_file`
 il quale genera il file docker-compose-production.yml con le impostazioni necessarie per il deploy,
 seguire poi le istruzioni aggiuntive visualizzate mentre si lancia il task
 
 
 Task di capistrano aggiuntivi:
 * docker:db:push  -> Carica il database online (**Attenzione**, non viene richiesta conferma )
 * docker:db:pull  -> Scarica il database in sviluppo (**Attenzione**, non viene richiesta conferma )
 * docker:create_online_docker_compose_file -> Genera il file compose localmente per il deploy
  
## TODO ##
Altre funzionalità Work in Progress

* Globalize (per traduzione modelli specifici)
* Friendly ID (per link slag modelli specifici)
* Modello Proxy Essence (funzionalità proxy tra modello personalizzato ed elemento Alchemy )
* [https://github.com/presidentbeef/brakeman](https://github.com/presidentbeef/brakeman)
* [https://github.com/thredded/db_text_search](https://github.com/thredded/db_text_search)

  