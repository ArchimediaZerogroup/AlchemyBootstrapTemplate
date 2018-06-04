class Argument < CustomModel

  include AlchemyElementProxerConcern

  build_proxed_elements

  has_many :advices

  validates :name, presence: true

  before_destroy :prevent_delete_if_advices_not_empty

  private

  def prevent_delete_if_advices_not_empty

    unless advices.empty?
      errors.add(:base, :cant_delete_advices_not_empty)
      throw :abort
    end

  end

end
