json.total @photos.total_count
json.pages @photos.total_pages
json.current_page @photos.current_page
json.photos do
  json.array! @photos do |photo|
    json.partial! "api/v1/photos/photo", photo: photo
  end
end
