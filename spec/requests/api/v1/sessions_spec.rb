require 'swagger_helper'

RSpec.describe 'api/v1/sessions', type: :request do
  path '/api/v1/login' do
    post 'User Login' do
      tags 'Authentication'
      description 'Authenticate user and receive API token'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :session, in: :body, schema: {
        type: :object,
        properties: {
          session: {
            type: :object,
            properties: {
              email: { type: :string, example: 'user@example.com' },
              password: { type: :string, example: 'Password123!' }
            },
            required: ['email', 'password']
          }
        },
        required: ['session']
      }

      response '200', 'login successful' do
        schema type: :object,
               properties: {
                 token: { type: :string, description: 'API token for subsequent requests' },
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

        let!(:user) { create(:user) }
        let(:session) { { session: { email: user.email, password: 'Password123!' } } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['token']).to be_present
          expect(data['user']['email']).to eq(user.email)
        end
      end

      response '401', 'invalid credentials' do
        schema type: :object,
               properties: {
                 error: { type: :string }
               }

        let(:session) { { session: { email: 'wrong@example.com', password: 'wrongpass' } } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['error']).to eq('Invalid email or password')
        end
      end
    end
  end

  path '/api/v1/logout' do
    delete 'User Logout' do
      tags 'Authentication'
      description 'Invalidate the current user token'
      produces 'application/json'
      security [Bearer: []]

      parameter name: :Authorization, in: :header, type: :string, required: true,
                description: 'API token (format: Bearer YOUR_TOKEN)'

      response '204', 'logout successful' do
        let!(:user) { create(:user) }
        let(:Authorization) { "Bearer #{user.api_token}" }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'Bearer invalid_token' }

        run_test!
      end
    end
  end
end
