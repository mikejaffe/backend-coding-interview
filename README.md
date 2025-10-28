# Photos API

A RESTful API for managing photos and photographers with token-based authentication.

## Quick Start (Local Development)

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
- Rails 8 for rapid API development, SQLite is suffecient for this purpose. Postgres would be my choice for prouction.

**Simple Token Based Authentication**
- Simpler implementation for time-constrained challenge, would most likely use OAUTH or JWT in production apps

**external_xxx columns**
- In the photos and photographers models, I've made a design decision to make this scalable to handle any source. The idea being that the app could house photos from various providers.

**JSON Columns for Photo URLs**
- Store multiple image sizes efficiently in a single column which makes it easy to add/remove image sizes without migrations

**Soft Deletes**
- Preserve data integrity by marking records as deleted vs hard deletes and allows recovery if needed
- Maintains referential integrity


## Testing

### Run Tests

```bash
# All tests
bundle exec rspec

```


## What I'd Add for a more robust solution if more time was allowed.
 
- More Search & Filtering - Full-text search, filter by dimensions, date ranges
- Rate Limiting - Prevent API abuse (Rack::Attack)
- Caching - Redis for frequently accessed photos and photographers
- Photo uploads?? using carrier wave and S3

 
## Production Deployment

This app is configured for deployment with Kamal (Rails 8 default).

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

### Traditional Deployment

```bash
# Precompile assets
RAILS_ENV=production rails assets:precompile

# Run migrations
RAILS_ENV=production rails db:migrate

# Start with Puma
RAILS_ENV=production bundle exec puma -C config/puma.rb
```

## Import CSV Data

The CSV is automatically downloaded and imported:

```bash
rake import_csv
```