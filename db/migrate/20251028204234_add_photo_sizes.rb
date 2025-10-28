class AddPhotoSizes < ActiveRecord::Migration[8.0]
  def change
    add_column :photos, :width, :integer
    add_column :photos, :height, :integer
    add_column :photos, :src_urls, :text
  end
end
