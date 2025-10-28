# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.openapi_root = Rails.root.join('swagger').to_s

  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Photos API V1',
        version: 'v1',
        description: 'A RESTful API for photo management with user authentication'
      },
      paths: {},
      servers: [
        {
          url: 'http://localhost:3000',
          description: 'Development server'
        }
      ],
      components: {
        securitySchemes: {
          Bearer: {
            type: :apiKey,
            name: 'Authorization',
            in: :header,
            description: 'API token for authentication. Format: Bearer YOUR_TOKEN'
          }
        }
      }
    }
  }

  config.openapi_format = :yaml
end
