require 'swagger_helper'

RSpec.describe 'api/v1/photos', type: :request do
  let!(:user) { create(:user) }
  let(:Authorization) { "Bearer #{user.api_token}" }

  path '/api/v1/photos' do
    get 'List photos' do
      tags 'Photos'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :Authorization, in: :header, type: :string
      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :per_page, in: :query, type: :integer, required: false
      parameter name: :photographer_id, in: :query, type: :integer, required: false

      response '200', 'success' do
        let!(:photos) { create_list(:photo, 3) }
        run_test!
      end

      response '200', 'filtered by photographer' do
        let!(:photographer) { create(:photographer) }
        let!(:photos) { create_list(:photo, 2, photographer: photographer) }
        let(:photographer_id) { photographer.id }
        run_test!
      end
    end

    post 'Create photo' do
      tags 'Photos'
      consumes 'application/json'
      security [ Bearer: [] ]

      parameter name: :Authorization, in: :header, type: :string
      parameter name: :photo, in: :body, schema: {
        type: :object,
        properties: {
          photo: {
            type: :object,
            properties: {
              photographer_id: { type: :integer },
              external_id: { type: :string },
              width: { type: :integer },
              height: { type: :integer },
              src_urls: { type: :object }
            }
          }
        }
      }

      response '201', 'created' do
        let!(:photographer) { create(:photographer) }
        let(:photo) do
          {
            photo: {
              photographer_id: photographer.id,
              external_id: "12345",
              width: 4000,
              height: 3000,
              src_urls: {
                original: "https://example.com/original.jpg",
                medium: "https://example.com/medium.jpg"
              }
            }
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/photos/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Get photo' do
      tags 'Photos'
      security [ Bearer: [] ]
      parameter name: :Authorization, in: :header, type: :string

      response '200', 'found' do
        let!(:photo_record) { create(:photo) }
        let(:id) { photo_record.id }
        run_test!
      end

      response '404', 'not found' do
        let(:id) { 99999 }
        run_test!
      end
    end

    delete 'Delete photo' do
      tags 'Photos'
      security [ Bearer: [] ]
      parameter name: :Authorization, in: :header, type: :string

      response '200', 'deleted' do
        let!(:photo_record) { create(:photo) }
        let(:id) { photo_record.id }
        run_test!
      end
    end
  end
end
