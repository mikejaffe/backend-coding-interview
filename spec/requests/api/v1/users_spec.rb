require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  path '/api/v1/signup' do
    post 'User Registration' do
      tags 'Users'
      description 'Create a new user account'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              name: { type: :string, example: 'John Doe' },
              email: { type: :string, example: 'john@example.com' },
              password: { type: :string, example: 'Password123!' }
            },
            required: ['name', 'email', 'password']
          }
        },
        required: ['user']
      }

      response '201', 'user created' do
        schema type: :object,
               properties: {
                 token: { type: :string, description: 'API token for the new user' },
                 user: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     name: { type: :string },
                     email: { type: :string }
                   }
                 }
               },
               required: ['token', 'user']

        let(:user) { { user: { name: 'Jane Doe', email: 'jane@example.com', password: 'Password123!' } } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['token']).to be_present
          expect(data['user']['email']).to eq('jane@example.com')
          expect(data['user']['name']).to eq('Jane Doe')
        end
      end

      response '422', 'invalid request' do
        schema type: :object,
               properties: {
                 errors: {
                   type: :array,
                   items: { type: :string }
                 }
               }

        let(:user) { { user: { name: '', email: 'invalid', password: '' } } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to be_an(Array)
          expect(data['errors']).not_to be_empty
        end
      end
    end
  end
end

