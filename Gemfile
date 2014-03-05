source 'https://rubygems.org'
ruby '2.0.0'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'bcrypt-ruby', '~>3.1.2'
gem 'bootstrap_form'
gem 'sidekiq'
gem 'unicorn'

group :development do
  gem 'sqlite3'
  gem 'thin'
  gem 'meta_request'
  gem 'letter_opener'
  gem 'sinatra', require: false
  gem 'slim'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'pry'
  gem 'pry-nav'
  gem 'faker'
  gem 'fabrication'
end

group :test do
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'launchy'
  gem 'capybara-email'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

