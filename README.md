# Butler API

This is the backend of Butler. It will contain various API endpoints and service
integrations. It is a Rails app using Grape API for the endpoints and Postgres
for the database.

## Configuration

Environment config is set in the application.yml file. It is not committed to
this repo. You will need to get it from someone.

## Database initialization

- `rake db:create:all`
- `rake db:migrate`

## How to run the test suite

The fixtures and application.yml are not committed to this repo so the tests
will not run on anyone but Jake's machine. We'll need to figure out a way to do
this in the future but there is sensitive data that gives full access to
freshbooks that we have to keep safe.

## Deployment instructions

TODO
