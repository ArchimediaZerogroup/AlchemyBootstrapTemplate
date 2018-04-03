class CreateUserSiteRegistrations < ActiveRecord::Migration[5.1]
  def change
    create_table :user_site_registrations do |t|
      t.string :email
      t.string :type
      t.text :serialized_data

      t.timestamps
    end
  end
end