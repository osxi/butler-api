source 'https://rubygems.org'

ruby '2.1.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.6'
# Use sqlite3 as the database for Active Record
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# bundle exec rake doc:rails generates the API under doc/api.

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

gem "rack-handlers"
gem "rack-cors", require: "rack/cors"
gem "unicorn"
gem "figaro"
gem "pg"
gem "jsonapi-resources"
gem "ruby-freshbooks"
gem "ruby-trello"
gem "airbrake"
gem "httparty"
gem "wannabe_bool"
gem "devise"
gem "rails_admin"

gem 'materialize_rails'

group :production, :staging do
  gem "rails_12factor"
  gem "hirefire-resource"
end

group :development do
  gem "quiet_assets"
  gem "guard"
  gem "guard-unicorn"
  gem "guard-rspec", require: false
  gem "guard-rubocop"
  gem "guard-brakeman"
  gem "rubocop", require: false
  gem "brakeman", require: false
  gem "bullet"
  gem "pry-rails"
  gem "spring-commands-rspec"
end

group :development, :test do
  gem "factory_girl_rails"
  gem "byebug"
  gem "rspec-rails"
  gem "rspec-its"
  gem "database_cleaner"
  gem "better_errors"
  gem "binding_of_caller"
  gem "awesome_print"
  gem "rb-fsevent", require: false
end

group :test do
  gem "coveralls", require: false
  gem "shoulda-matchers"
  gem "vcr"
  gem "webmock"
end

gem "grape"
gem "grape-active_model_serializers"
gem "grape-swagger-rails"
