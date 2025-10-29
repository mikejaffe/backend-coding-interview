require 'swagger_helper'

RSpec.describe 'api/v1/photographers', type: :request do
  let!(:user) { create(:user) }
  let(:Authorization) { "Bearer #{user.api_token}" }

  path '/api/v1/photographers' do
    get 'List photographers' do
      tags 'Photographers'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :Authorization, in: :header, type: :string
      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :per_page, in: :query, type: :integer, required: false
      parameter name: :name, in: :query, type: :string, required: false

      response '200', 'success' do
        let!(:photographers) { create_list(:photographer, 2) }
        run_test!
      end

      response '200', 'filtered by name' do
        let!(:photographer1) { create(:photographer, name: 'John Smith') }
        let!(:photographer2) { create(:photographer, name: 'Jane Doe') }
        let(:name) { 'John' }
        run_test!
      end
    end

    post 'Create photographer' do
      tags 'Photographers'
      consumes 'application/json'
      security [ Bearer: [] ]

      parameter name: :Authorization, in: :header, type: :string
      parameter name: :photographer, in: :body, schema: {
        type: :object,
        properties: {
          photographer: {
            type: :object,
            properties: {
              name: { type: :string },
              external_id: { type: :string },
              external_service: { type: :string }
            }
          }
        }
      }

      response '201', 'created' do
        let(:photographer) do
          {
            photographer: {
              name: "John Doe",
              external_id: "123"
            }
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/photographers/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Get photographer' do
      tags 'Photographers'
      security [ Bearer: [] ]
      parameter name: :Authorization, in: :header, type: :string

      response '200', 'found' do
        let!(:photographer_record) { create(:photographer) }
        let(:id) { photographer_record.id }
        run_test!
      end

      response '404', 'not found' do
        let(:id) { 99999 }
        run_test!
      end
    end

    put 'Update photographer' do
      tags 'Photographers'
      consumes 'application/json'
      security [ Bearer: [] ]
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :photographer, in: :body, schema: {
        type: :object,
        properties: {
          photographer: {
            type: :object,
            properties: {
              name: { type: :string }
            }
          }
        }
      }

      response '200', 'updated' do
        let!(:photographer_record) { create(:photographer) }
        let(:id) { photographer_record.id }
        let(:photographer) { { photographer: { name: "Updated Name" } } }
        run_test!
      end
    end

    delete 'Delete photographer' do
      tags 'Photographers'
      security [ Bearer: [] ]
      parameter name: :Authorization, in: :header, type: :string

      response '200', 'deleted' do
        let!(:photographer_record) { create(:photographer) }
        let(:id) { photographer_record.id }
        run_test!
      end
    end
  end
end
