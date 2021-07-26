module CommonUtilsMethods

  extend ActiveSupport::Concern

  included do

    def to_url
      layout = Alchemy::PageLayout.get_all_by_attributes(custom_model: self.class.to_s).select {|ly| ly["custom_model_action"] == "show"}.first
      page = Alchemy::Language.current.pages.find_by(page_layout: layout["name"]).parent
      page.urlname
    end

    def ui_title
      self.class.to_s.demodulize.downcase
    end

    def breadcrumb_name
      self.class.to_s.demodulize.titleize
    end

    def self.only_current_language
      all
    end


  end
end