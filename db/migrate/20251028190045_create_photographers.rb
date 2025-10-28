class CreatePhotographers < ActiveRecord::Migration[8.0]
  def change
    create_table :photographers do |t|
      t.string :name, null: false
      t.string :external_avatar_url
      t.string :external_service
      t.string :external_id
      t.string :external_url
      t.string :avg_color
      t.timestamps
    end
  end
end
