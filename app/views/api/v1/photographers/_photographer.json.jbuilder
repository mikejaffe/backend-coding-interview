json.extract! photographer, :id, :name, :external_avatar_url, :external_url, :external_service, :external_id
json.photo_count photographer.respond_to?(:photo_count) ? photographer.photo_count : photographer.photos.count
