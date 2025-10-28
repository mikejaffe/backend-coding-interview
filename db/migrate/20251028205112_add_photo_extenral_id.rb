class AddPhotoExtenralId < ActiveRecord::Migration[8.0]
  def change
    add_column :photos, :external_id, :string
  end
end
