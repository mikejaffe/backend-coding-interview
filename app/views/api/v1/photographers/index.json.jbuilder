json.total @photographers.total_count
json.pages @photographers.total_pages
json.current_page @photographers.current_page
json.photographers do
  json.array! @photographers do |photographer|
    json.partial! "api/v1/photographers/photographer", photographer: photographer
  end
end

