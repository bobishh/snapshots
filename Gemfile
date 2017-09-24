# frozen_string_literal: true
source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# setup
gem 'rake'
# dev
# http
gem 'sinatra'
gem 'thin'

# messaging
gem 'bunny'

# storage
gem 'rom'
gem 'rom-sql'
gem 'rom-repository'
gem 'sqlite3'
gem 'rack'

# specs
group :test do
  gem 'rspec'
  gem 'rack-test'
end

group :dev do
  gem 'pry'
  gem 'pry-byebug'
end
