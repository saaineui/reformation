ruby '2.6.6'
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '5.1.2'
gem 'puma', '4.3.11'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'bootstrap-sass'
gem 'jbuilder' # JSON APIs 
gem 'bcrypt', '~> 3.1.11'

group :development, :test do
  gem 'sqlite3'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 3.5'
end

group :development do
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. 
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :test do
  gem 'shoulda-matchers', '3.1.2'
  gem 'simplecov', require: false
end

group :production do
  gem 'pg', '0.21.0'
end
