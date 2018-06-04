module ArchimediaPgsearch
  SEARCH_RESULTS_PAGINATION_NUMBER = 10

  SEARCHABLE_ESSENCES = ["EssenceText", "EssenceRichtext", "EssenceHtml"]


  def self.is_searchable_essence? essence_type
    SEARCHABLE_ESSENCES.include?(essence_type)

  end


end