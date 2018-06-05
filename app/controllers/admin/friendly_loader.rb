require 'active_support/concern'

module Admin
  module FriendlyLoader
    extend ActiveSupport::Concern

    included do
      protected
      ##
      # Carica il modello, facendo l'override del metodo to_param per forzare l'utilizzo sempre dell'id così da ovviare
      # ai vari problemi di traduzione
      def load_resource
        if resource_handler.model.respond_to? :friendly
          record = I18n.with_locale(Alchemy::Language.current.language_code) {resource_handler.model.friendly.find(params[:id])}
        else
          record = I18n.with_locale(Alchemy::Language.current.language_code) {resource_handler.model.find(params[:id])}
        end
        record.extend(AdminOverrideToParam)
        instance_variable_set("@#{resource_handler.resource_name}", record)
      end

      private
      def resource_params
        base_params = super
        slug = base_params.delete(:slug)
        unless slug.blank?
          base_params[:slug] = slug
        end

        Rails.logger.debug {base_params.inspect}

        base_params
      end

    end

#  module ClassMethods

#  end
  end
end