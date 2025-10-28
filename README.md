<<<<<<< HEAD
# Clever's Backend Engineering Challenge
👋 Hello!, Hola!, Witam!

Thank you for taking the time to interview with Clever. This coding challenge is designed to see how you approach backend architecture, API design, and engineering best practices. We don't want this to take too much of your time (and if it does, certainly let us know!).

## Overview
Build a RESTful API for a photo management service using the provided photo dataset. This API should be production-ready, well-documented, and demonstrate your understanding of backend architecture, API design, and software engineering best practices.

## Core Requirements
The baseline functionality we expect:
- Ingest and store the provided photo data (photos.csv)
- Implement user authentication and authorization
- Provide API endpoints for managing and accessing photos
- Include comprehensive API documentation
- Write tests for your implementation

## What We Want to See
This is intentionally open-ended. We want to see what **you** think makes a great, production-ready API. Consider implementing features and patterns you'd expect in a real-world system. Choose what you think is most important and implement thoughtfully. Quality over quantity.

## Technology Choices
- **Backend Framework**: We primarily use Django and Ruby on Rails, but you're welcome to use whatever language and framework you're most proficient in (Python, Ruby, Node.js, Go, Java, etc.)
- **Database**: Your choice - pick what makes sense for the use case
- **Documentation**: Choose the format that best communicates your API design
- **Additional Tools**: Use whatever tools and libraries you believe are appropriate

## Data Source
We've provided `photos.csv` with photo data from Pexels. Each row represents a photo with details like dimensions, photographer information, various image sizes, and descriptions. Use this as your data source.

## Deliverables
Your submission should include:

1. **Working API** with clear setup instructions
2. **API Documentation** explaining available endpoints and how to use them
3. **Tests** demonstrating your testing approach
4. **README** that explains:
   - Architecture decisions and trade-offs you made
   - What features you implemented and why you prioritized them
   - How to run the application and tests
   - What you would add/change with more time
   - Any assumptions you made

## Evaluation Criteria
We'll be assessing:
- **API Design**: RESTful principles, resource modeling, endpoint design, consistency
- **Code Quality**: Organization, patterns, maintainability, readability
- **Database Design**: Schema design, relationships, indexing strategy
- **Security**: Authentication implementation, authorization, input validation
- **Error Handling**: Meaningful error messages, proper HTTP status codes, edge cases
- **Testing**: Test coverage, test quality, testing strategy
- **Documentation**: API docs, code documentation, setup instructions, decision rationale

## Time Expectation
We expect this to take **2-6 hours** of focused work. If you find yourself spending significantly more time, please document what you would do next rather than trying to complete everything. We value your time and want to see how you prioritize.

## Submission
- Fork this repo and commit your code there
- Open a PR from your fork back to the main repo
- Add the following users as reviewers so we can assess your work:
  - James Crain (@imjamescrain)
  - Jimmy Lien (@jlien)
  - Nick Clucas (@nickcluc)
  - Ryan McCue (@rymccue)

## Final Thoughts
This challenge is designed to be open-ended because we want to understand how you think about building systems, not just whether you can follow a specification. Show us your engineering judgment, your decision-making process, and what you believe "done" really means.

**Any questions?** Send emails to <a href="mailto:ryan@movewithclever.com">ryan@movewithclever.com</a>. Good luck!
=======
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
>>>>>>> 1c01381 (first commit)
