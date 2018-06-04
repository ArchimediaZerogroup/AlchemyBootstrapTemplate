class AddProxedElementIdToElement < ActiveRecord::Migration[5.1]
  def change
    add_reference :alchemy_elements, :proxed_element, index: true
  end
end
