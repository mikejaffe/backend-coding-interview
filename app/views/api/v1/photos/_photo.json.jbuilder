    json.extract! photo, :id, :width, :height
    json.external_id photo.external_id
    json.external_source photo.photographer.external_service
    json.photographer do
      json.extract! photo.photographer, :id, :name, :external_url
    end
    json.sizes do
      json.original photo.original_url
      json.large photo.large_url
      json.medium photo.medium_url
      json.small photo.small_url
      json.thumbnail photo.thumbnail_url
      json.portrait photo.portrait_url
      json.landscape photo.landscape_url
    end
