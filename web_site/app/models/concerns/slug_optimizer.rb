module SlugOptimizer

  extend ActiveSupport::Concern

  included do
    validates :slug, uniqueness: {:allow_nil => true}
    before_save :prevent_wrong_slug

    private
    def prevent_wrong_slug
      self.slug = normalize_friendly_id self.slug
    end
  end
end