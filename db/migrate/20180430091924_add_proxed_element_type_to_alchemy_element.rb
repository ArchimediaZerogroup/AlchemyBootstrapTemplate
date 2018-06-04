class AddProxedElementTypeToAlchemyElement < ActiveRecord::Migration[5.1]
  def change
    add_column :alchemy_elements, :proxed_element_type, :string
  end
end
