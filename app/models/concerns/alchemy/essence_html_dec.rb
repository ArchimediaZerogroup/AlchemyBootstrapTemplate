module Alchemy
  module EssenceHtmlDec

    extend ActiveSupport::Concern

    included do

      include ::Searchable

      include ::PgSearch
      multisearchable :against => [:stripped_body], if: ->(record){ record.searchable? }
    end

  end
end