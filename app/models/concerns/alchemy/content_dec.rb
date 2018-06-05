module Alchemy
  module ContentDec

    extend ActiveSupport::Concern

    included do


      def prepared_attributes_for_essence
        attributes = {
            ingredient: default_text(definition['default'])
        }
        if ArchimediaPgsearch.is_searchable_essence?(definition['type'])
          attributes.merge!(searchable: definition.fetch('searchable', true))
        end
        attributes
      end


    end
  end
end