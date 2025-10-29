require 'rails_helper'

RSpec.describe Photographer, type: :model do
  describe 'associations' do
    it 'has many photos' do
      photographer = create(:photographer)
      photo1 = create(:photo, photographer: photographer)
      photo2 = create(:photo, photographer: photographer)

      expect(photographer.photos.count).to eq(2)
      expect(photographer.photos).to include(photo1, photo2)
    end
  end
end
