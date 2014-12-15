# Butler API [![Code Climate](https://codeclimate.com/github/poetic/butler-api/badges/gpa.svg)](https://codeclimate.com/github/poetic/butler-api)

*This is currently an internal project so it's very specific to our process. We
plan on making it more configurable and provide docs and ways for others to set
it up sometime in the future. There is no ETA on that currently.*

This is the backend of Butler. It will contain various API endpoints and service
integrations. It is a Rails app using Grape API for the endpoints and Postgres
for the database.

## Configuration

Environment config is set in the application.yml file. It is not committed to
this repo. You will need to get it from someone at Poetic.

## Database initialization

- `rake db:create:all`
- `rake db:migrate`

## How to run the test suite

You'll need to get a copy of the `application.yml` from someone at Poetic so
that the test servers are used and your fixtures are generated.

## Deployment instructions

[@jakecraige](github.com/jakecraige) can do pushes to produciton after your
changes are merged into master and testa rea passing.
