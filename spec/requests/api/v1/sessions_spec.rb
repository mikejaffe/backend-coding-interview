require 'swagger_helper'

RSpec.describe 'api/v1/sessions', type: :request do
  path '/api/v1/login' do
    post 'Login' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :session, in: :body, schema: {
        type: :object,
        properties: {
          session: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string }
            }
          }
        }
      }

      response '200', 'success' do
        let!(:user) { create(:user) }
        let(:session) { { session: { email: user.email, password: 'Password123!' } } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['token']).to be_present
        end
      end

      response '401', 'invalid credentials' do
        let(:session) { { session: { email: 'wrong@example.com', password: 'wrongpass' } } }
        run_test!
      end
    end
  end

  path '/api/v1/logout' do
    delete 'Logout' do
      tags 'Authentication'
      security [Bearer: []]

      parameter name: :Authorization, in: :header, type: :string

      response '204', 'logged out' do
        let!(:user) { create(:user) }
        let(:Authorization) { "Bearer #{user.api_token}" }
        run_test!
      end
    end
  end
end
