source 'https://rubygems.org'

ruby '2.2.1'

gem 'pg'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5.1'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer',  platforms: :ruby, group: :test

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# An email validator for Rails 3 and 4.
gem 'email_validator'

# Bootstrap Sass for Rails
gem 'bootstrap-sass', '~> 3.2.0'
gem 'autoprefixer-rails'

# Font Awesome for Rails
gem "font-awesome-rails"

# Angular.js for Rails
gem 'angularjs-rails', '~> 1.2.20'

# Angular.js UI bootstrap for Rails
gem 'angular-ui-bootstrap-rails', '~> 0.11.0'

# Chosen Javascript for Rails
gem 'chosen-rails', '~> 1.1.0'

# Bootstrap for Chosen Javascript
gem 'chosen-sass-bootstrap-rails', '~> 0.0.2'

gem 'holidays', '~> 3.2.0'

gem 'sentry-raven'

gem 'statesman'

# ruby app server
# https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server
gem 'puma'
gem 'silencer'
gem 'newrelic_rpm'

gem "interactor-rails", "~> 2.0"


group :production do
  gem 'rails_12factor'
end

group :development do
  gem 'letter_opener'
  gem 'letter_opener_web'
  gem 'web-console', '~> 2.0'
end

group :development, :test do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'rspec-rails', '~> 3.4.0'
  gem 'rspec-collection_matchers'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'pry'
  gem 'pry-byebug'
  gem 'dotenv-rails'
  gem 'quiet_assets'
  gem 'simplecov'
end

gem 'codeclimate-test-reporter', group: :test, require: nil
