# This migration comes from alchemy_custom_model (originally 20200424184007)
class AddFieldsToNode < ActiveRecord::Migration[5.2]
  def change
    if "Alchemy::Node".safe_constantize
      add_column :alchemy_nodes, :custom_model_klass, :string
      add_column :alchemy_nodes, :custom_model_method, :string
    end
  end
end
