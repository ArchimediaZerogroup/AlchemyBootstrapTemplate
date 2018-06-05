module Alchemy
  module PageDec

    extend ActiveSupport::Concern

    included do

      def self.search(query)
        search_results = []
        results = ::PgSearch.multisearch(query)
        results.each do |rs|
          search_results << ::SearchResult.new(rs)
        end
        avaiable_pages_ids= Alchemy::Page.published.contentpages.from_current_site.with_language(Alchemy::Language.current.id).
            not_restricted.pluck(:id)
        search_results.select{|prs| (prs.is_from_page? and !prs.page.nil? and avaiable_pages_ids.include? prs.page.id) or
            (prs.is_from_custom_model? and prs.custom_model.only_current_language.pluck(:id).include? prs.custom_model_instance.id)
        }
      end

    end
  end
end