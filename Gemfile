# A sample Gemfile
source "https://rubygems.org"

gem 'dotenv'
gem "rake"

gem "grape"
gem "sequel"

gem 'puma'

gem 'microscope_tracer', '~> 0.2.0'
#gem 'request_store'

gem 'cloudfoundry-deploy', :git => 'https://github.com/ThoughtWorks-AELab/cloudfoundry-deploy.git'

group :production do
  gem 'pg'
end

group :development, :test do
  gem 'foreman'
  gem 'sqlite3'
  gem 'rspec', '~> 3.3.0'
  gem 'ci_reporter_rspec'
  gem 'pry'
end

group :development do
  gem 'pry-nav'
end

