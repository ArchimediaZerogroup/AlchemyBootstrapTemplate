class CreateAdvices < ActiveRecord::Migration[5.1]
  def change
    create_table :advices do |t|
      t.date :validity_date
      t.date :publication_date
      t.string :title
      t.text :description

      t.timestamps
    end

  end
end
