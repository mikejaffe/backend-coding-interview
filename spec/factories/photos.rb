FactoryBot.define do
  factory :photo do
    association :photographer
    sequence(:external_id) { |n| "photo_#{n}" }
    width { 4000 }
    height { 3000 }
    src_urls do
      {
        "original" => "https://images.pexels.com/original.jpg",
        "large" => "https://images.pexels.com/large.jpg",
        "medium" => "https://images.pexels.com/medium.jpg",
        "small" => "https://images.pexels.com/small.jpg",
        "tiny" => "https://images.pexels.com/tiny.jpg",
        "portrait" => "https://images.pexels.com/portrait.jpg",
        "landscape" => "https://images.pexels.com/landscape.jpg"
      }
    end
  end
end
