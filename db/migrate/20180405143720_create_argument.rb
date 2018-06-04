class CreateArgument < ActiveRecord::Migration[5.1]
  def change
    create_table :arguments do |t|
      t.timestamps
      t.string :name
      t.string :description
    end


  end
end
