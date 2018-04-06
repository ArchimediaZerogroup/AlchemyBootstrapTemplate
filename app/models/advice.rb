class Advice < ApplicationRecord

  include AlchemyElementProxerConcern

  # Only if globalize gem loaded
  # translates :title, :description, :slug, touch: true

  # Only if friendly_id gem loaded
  # extend FriendlyId
  # friendly_id :title, :use => [:globalize, :history] #[:history, :globalize, :finders]

  build_proxed_elements

  validates :title, :description, :publication_date, presence: true



end
