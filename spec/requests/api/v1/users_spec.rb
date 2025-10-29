require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  path '/api/v1/signup' do
    post 'Sign Up' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              name: { type: :string },
              email: { type: :string },
              password: { type: :string }
            }
          }
        }
      }

      response '201', 'created' do
        let(:user) { { user: { name: 'Jane Doe', email: 'jane@example.com', password: 'Password123!' } } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['token']).to be_present
        end
      end

      response '422', 'validation error' do
        let(:user) { { user: { name: '', email: 'invalid', password: '' } } }
        run_test!
      end
    end
  end
end
