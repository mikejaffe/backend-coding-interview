require 'swagger_helper'

RSpec.describe 'api/v1/photos', type: :request do
  let!(:user) { create(:user) }
  let(:Authorization) { "Bearer #{user.api_token}" }

  path '/api/v1/photos' do
    get 'List Photos' do
      tags 'Photos'
      description 'Get paginated list of photos'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :Authorization, in: :header, type: :string, required: true
      parameter name: :page, in: :query, type: :integer, required: false, description: 'Page number'
      parameter name: :per_page, in: :query, type: :integer, required: false, description: 'Items per page'
      parameter name: :photographer_id, in: :query, type: :integer, required: false, description: 'Filter by photographer ID'

      response '200', 'photos retrieved' do
        let!(:photos) { create_list(:photo, 3) }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['photos']).to be_an(Array)
          expect(data['total']).to be_present
        end
      end


      response '200', 'photos retrieved by photographer' do
        let!(:photographer) { create(:photographer) }
        let!(:photos) { create_list(:photo, 3, photographer: photographer) }
        let(:photographer_id) { photographer.id }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'Bearer invalid' }
        run_test!
      end
    end

    post 'Create Photo' do
      tags 'Photos'
      description 'Create a new photo'
      consumes 'application/json'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :Authorization, in: :header, type: :string, required: true
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
              src_urls: {
                type: :object,
                properties: {
                  original: { type: :string },
                  large: { type: :string },
                  medium: { type: :string },
                  small: { type: :string },
                  tiny: { type: :string }
                }
              }
            },
            required: [ 'photographer_id', 'src_urls' ]
          }
        }
      }

      response '201', 'photo created' do
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
                large: "https://example.com/large.jpg",
                medium: "https://example.com/medium.jpg",
                small: "https://example.com/small.jpg",
                tiny: "https://example.com/tiny.jpg"
              }
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['id']).to be_present
          expect(data['sizes']['original']).to eq('https://example.com/original.jpg')
        end
      end

      response '422', 'invalid parameters' do
        let(:photo) { { photo: { width: 100 } } }
        run_test!
      end
    end
  end

  path '/api/v1/photos/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Photo ID'

    get 'Show Photo' do
      tags 'Photos'
      description 'Get a single photo by ID'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :Authorization, in: :header, type: :string, required: true

      response '200', 'photo found' do
        let!(:photo_record) { create(:photo) }
        let(:id) { photo_record.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['id']).to eq(photo_record.id)
          expect(data['photographer']).to be_present
        end
      end

      response '404', 'photo not found' do
        let(:id) { 99999 }
        run_test!
      end
    end

    delete 'Delete Photo' do
      tags 'Photos'
      description 'Soft delete a photo'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :Authorization, in: :header, type: :string, required: true

      response '200', 'photo deleted' do
        let!(:photo_record) { create(:photo) }
        let(:id) { photo_record.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eq('Photo deleted')
        end
      end

      response '404', 'photo not found' do
        let(:id) { 99999 }
        run_test!
      end
    end
  end
end
