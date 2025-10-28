class CreatePhotos < ActiveRecord::Migration[8.0]
  def change
    create_table :photos do |t|
      t.references :photographer, null: false, foreign_key: true
      t.timestamps
    end
  end
end
