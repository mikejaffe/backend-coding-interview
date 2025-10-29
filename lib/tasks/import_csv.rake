task import_csv: :environment do
  require "csv"
  require "open-uri"


  csv_file = File.read(Rails.root.join("photos.csv"))
  csv = CSV.parse(csv_file, headers: true)
  csv.each do |row|
    photographer = Photographer.find_or_initialize_by(external_id: row["photographer_id"])
    photographer.name = row["photographer"]
    photographer.external_service = row["source"] || "pexels"
    photographer.external_url = row["photographer_url"]
    photographer.save!
    photo = Photo.find_or_initialize_by(external_id: row["id"])
    photo.update!(
      photographer_id: photographer.id,
      width: row["width"],
      height: row["height"],
      src_urls: {
        original: row["src.original"],
        large2x: row["src.large2x"],
        large: row["src.large"],
        medium: row["src.medium"],
        small: row["src.small"],
        portrait: row["src.portrait"],
        landscape: row["src.landscape"],
        tiny: row["src.tiny"]
      },
      external_id: row["id"]
    )
  end
end
