source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '5.1.2'
gem 'puma', '3.9.1'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'bootstrap-sass'
gem 'jbuilder' # JSON APIs 
gem 'bcrypt', '~> 3.1.11'

group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails', '~> 3.5'
end

group :development do
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. 
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :production do
  gem 'pg', '0.21.0'
end
