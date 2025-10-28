require 'rails_helper'

RSpec.describe Photo, type: :model do
  let(:photo) { create(:photo) }

  describe 'with invalid JSON' do
    it 'handles gracefully' do
      photo.update_column(:src_urls, 'invalid json')
      expect(photo.src_urls_hash).to eq({})
    end
  end
end
