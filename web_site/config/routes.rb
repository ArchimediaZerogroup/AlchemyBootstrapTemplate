Rails.application.routes.draw do
  
 mount Alchemy::Custom::Model::Engine => '/alchemy-custom-model'
mount Alchemy::Engine => '/'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
