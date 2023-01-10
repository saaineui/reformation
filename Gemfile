ruby '3.1.2'
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '7.0.3'
gem 'puma', '5.6.5'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'bootstrap-sass'
gem 'jbuilder' # JSON APIs 
gem 'bcrypt', '~> 3.1.18'
gem 'pg', '1.4.3'

group :development, :test do
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 5.1.2'
end

group :development do
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. 
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :test do
  gem 'shoulda-matchers', '5.1.0'
  gem 'simplecov', require: false
end
