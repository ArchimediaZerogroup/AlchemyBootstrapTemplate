class CustomModel < ApplicationRecord
  self.abstract_class = true

  include AlchemyElementProxerConcern


  scope :only_current_language, -> {
    where(language_id: Alchemy::Language.current)
  }

  # def self.skipped_alchemy_resource_attributes
  #   restricted_alchemy_resource_attributes
  # end

  def self.restricted_alchemy_resource_attributes
    [:language, :language_id]
  end

  def to_url
    layout = Alchemy::PageLayout.get_all_by_attributes(custom_model: self.class.to_s).select{ |ly| ly["custom_model_action"]=="show"}.first
    page = Alchemy::Language.current.pages.find_by(page_layout: layout["name"]).parent
    page.urlname
  end

  def ui_title
    self.class.to_s.demodulize.downcase
  end

  def breadcrumb_name
    self.class.to_s.demodulize.titleize
  end
end

