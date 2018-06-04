module Searchable

  extend ActiveSupport::Concern

  included do
    before_update do
      write_attribute(:searchable, definition.fetch('searchable', true))
      true
    end
  end
end