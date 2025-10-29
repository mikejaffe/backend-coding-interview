FactoryBot.define do
  factory :photographer do
    sequence(:name) { |n| "Photographer #{n}" }
    sequence(:external_id) { |n| "ext_#{n}" }
    external_service { "pexels" }
    external_url { "https://www.pexels.com/@photographer" }
  end
end
