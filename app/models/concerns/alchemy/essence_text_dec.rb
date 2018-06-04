module Alchemy
  module EssenceTextDec

    extend ActiveSupport::Concern

    included do

      include ::Searchable

      include ::PgSearch
      multisearchable :against => [:body], if: ->(record){ record.searchable? }


    end
  end
end