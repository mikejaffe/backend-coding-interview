class RemovePhotogAvatarUrl < ActiveRecord::Migration[8.0]
  def change
    remove_column :photographers, :external_avatar_url
  end
end
