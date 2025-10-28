require 'swagger_helper'

RSpec.describe 'api/v1/photographers', type: :request do
  let!(:user) { create(:user) }
  let(:Authorization) { "Bearer #{user.api_token}" }

  path '/api/v1/photographers' do
    get 'List Photographers' do
      tags 'Photographers'
      description 'Get paginated list of photographers'
      produces 'application/json'
      security [Bearer: []]
      
      parameter name: :Authorization, in: :header, type: :string, required: true
      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :per_page, in: :query, type: :integer, required: false

      response '200', 'photographers retrieved' do
        let!(:photographers) { create_list(:photographer, 2) }
        
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['photographers']).to be_an(Array)
          expect(data['photographers'].length).to eq(2)
        end
      end
    end

    post 'Create Photographer' do
      tags 'Photographers'
      description 'Create a new photographer'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: []]
      
      parameter name: :Authorization, in: :header, type: :string, required: true
      parameter name: :photographer, in: :body, schema: {
        type: :object,
        properties: {
          photographer: {
            type: :object,
            properties: {
              name: { type: :string },
              external_id: { type: :string },
              external_service: { type: :string },
              external_url: { type: :string },
              external_avatar_url: { type: :string }
            },
            required: ['name']
          }
        }
      }

      response '201', 'photographer created' do
        let(:photographer) do
          {
            photographer: {
              name: "John Doe",
              external_id: "123",
              external_service: "pexels",
              external_url: "https://pexels.com/@john"
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['name']).to eq('John Doe')
        end
      end
    end
  end

  path '/api/v1/photographers/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Photographer ID'

    get 'Show Photographer' do
      tags 'Photographers'
      description 'Get a single photographer by ID'
      produces 'application/json'
      security [Bearer: []]
      
      parameter name: :Authorization, in: :header, type: :string, required: true

      response '200', 'photographer found' do
        let!(:photographer_record) { create(:photographer) }
        let(:id) { photographer_record.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['id']).to eq(photographer_record.id)
          expect(data['name']).to be_present
        end
      end

      response '404', 'photographer not found' do
        let(:id) { 99999 }
        run_test!
      end
    end

    delete 'Delete Photographer' do
      tags 'Photographers'
      description 'Soft delete a photographer'
      produces 'application/json'
      security [Bearer: []]
      
      parameter name: :Authorization, in: :header, type: :string, required: true

      response '200', 'photographer deleted' do
        let!(:photographer_record) { create(:photographer) }
        let(:id) { photographer_record.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eq('Photographer deleted')
        end
      end

      response '404', 'photographer not found' do
        let(:id) { 99999 }
        run_test!
      end
    end
  end
end

