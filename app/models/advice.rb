class Advice < CustomModel

  build_proxed_elements

  belongs_to :argument, required: true

  extend FriendlyId

  friendly_id :title, :use => [:history] #[:history, :globalize, :finders]

  validates :title, :description, :publication_date,  presence: true

  #validates :slug, length: { minimum: 3 }, uniqueness: { allow_blank: true }
  #
  ransackable_associations = [:argument]

  def ui_title
    self.title
  end

  def self.alchemy_resource_relations
    {:argument=>{
        collection: Argument.only_current_language
    }}
  end

  def breadcrumb_name
    self.title
  end


end
