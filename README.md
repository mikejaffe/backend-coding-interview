# Photos API

A RESTful API for managing photos and photographers with token-based authentication.

## Quick Start

### Prerequisites
- Ruby 3.4.7
- SQLite 3.4+
- Bundler

### Setup

```bash
# Install dependencies
bundle install

# Setup database and import sample photos
rails db:setup
rake import_csv

# Start the server
rails server
```

The API will be available at `http://localhost:3000`

**API Documentation:** http://localhost:3000/api-docs

## API Overview

### Authentication
All endpoints (except signup/login) require authentication via Bearer token:

```bash
# 1. Sign up
curl -X POST http://localhost:3000/api/v1/signup \
  -H "Content-Type: application/json" \
  -d '{"user": {"name": "John Doe", "email": "john@example.com", "password": "Password123!"}}'

# 2. Use the returned token
curl -X GET http://localhost:3000/api/v1/photos \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```
 

## Architecture Decisions

**Rails 8 + SQLite**
- Rails 8 for rapid API development, SQLite is sufficient for this purpose. Postgres would be my choice for production.

**Simple Token Based Authentication**
- Simpler implementation for time-constrained challenge, would most likely use OAUTH / JWT in production apps

**external_xxx columns**
- In the photos and photographers models, I've made a design decision to make this scalable to handle any source. The idea being that the app could house photos from various providers.

**JSON Columns for Photo URLs**
- Store multiple image sizes efficiently in a single column which makes it easy to add/remove image sizes without migrations. Since urls are most likely not to be a part of any deep searching, seems like a safe bet. In Postgres, which I'd use for a production app, jsonb field are indexable and searchable. So this would be a reporting solution if needed.

**Soft Deletes**
- Preserve data integrity by marking records as deleted vs hard deletes and allows recovery if needed
- Maintains referential integrity, and audit friendly.

## Testing

### Run Tests

```bash
# All tests
bundle exec rspec

```


## What I'd add if more time was allowed.
 
- More Search & Filtering - Full-text search,  
- Rate Limiting - Prevent API abuse ([Rack::Attack](https://github.com/rack/rack-attack))
- Caching - Redis for frequently accessed photos and photographers
- Photo uploads?? using carrier wave and S3
- Background jobs with Sidekiq for uploads
- Counter caching for Photographer Photos

 
## Production Deployment

Rails 8 comes with a Dockerfile and ([Kamal](https://kamal-deploy.org/)) for deployments .

### Environment Variables

Create a `.env` file with:

```bash
# Database (for production you'd use PostgreSQL)
DATABASE_URL=postgresql://user:pass@localhost/photos_api_production

```

### Deploy with Kamal

```bash
# Setup (first time)
kamal setup

# Deploy updates
kamal deploy
```
 

## Import CSV Data

```bash
rake import_csv
```