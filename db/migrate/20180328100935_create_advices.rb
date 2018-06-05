class CreateAdvices < ActiveRecord::Migration[5.1]
  def change
    create_table :advices do |t|
      t.date :validity_date
      t.date :publication_date
      t.string :title
      t.text :description

      t.string :slug

      t.string :meta_title
      t.text :meta_description
      t.text :meta_keywords
      t.boolean :robot_index
      t.boolean :robot_follow

      t.timestamps
    end


    add_reference :advices, :language

  end
end
