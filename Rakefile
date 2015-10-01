require 'rake'
require 'dotenv/tasks'
require 'securerandom'
require "sequel"
require 'json'

namespace :spec do
  begin
    require 'rspec/core'
    require 'rspec/core/rake_task'
    require 'ci/reporter/rake/rspec'

    RSpec::Core::RakeTask.new(:unit) do |spec|
      spec.pattern = FileList['spec/unit/*_spec.rb']
    end
    task :unit => 'ci:setup:rspec'

    RSpec::Core::RakeTask.new(:functional) do |spec|
      spec.pattern = FileList['spec/functional/*_spec.rb']
    end
    task :functional => 'ci:setup:rspec'
  rescue LoadError
  end
end

desc "run local server"
task :server do
  exec "foreman start"
end

namespace :db do
  desc "Run migrations"
  task :migrate, [:version] => :dotenv do |t, args|
    if ENV['VCAP_SERVICE']
      VCAP_SERVICES = JSON.parse(ENV['VCAP_SERVICES'])
      db_url = VCAP_SERVICES["elephantsql"][0]["credentials"]["uri"]
    else
      db_url = ENV.fetch("DATABASE_URL")
    end

    version = args[:version]
    Sequel.extension :migration
    db = Sequel.connect(db_url)
    if version
      puts "Migrating to version #{version}"
      Sequel::Migrator.run(db, "db_migrations", target: version.to_i)
    else
      puts "Migrating to latest"
      Sequel::Migrator.run(db, "db_migrations")
    end
  end
end

namespace :app do
  desc "push to cloud foundry"
  task :deploy, [:space, :prefix] do |t, args|
    space = args[:space]
    prefix = args[:prefix]
    app_name = "#{prefix}_pricing"
    db_name = "#{app_name}-db"

    puts "deploying..."
    begin
      puts `cf login -a api.run.pivotal.io -u #{ENV['CF_USERNAME']} -p #{ENV['CF_PASSWORD']} -o TW-org -s #{space}`
      puts `cf create-service elephantsql turtle #{db_name}`
      puts `cf push #{app_name} -n #{app_name} --no-start`
      puts `cf bind-service #{app_name} #{db_name}`
      puts `cf push #{app_name} -n #{app_name} -c 'bundle exec rake db:migrate && bundle exec puma -C puma.rb'`
      puts `cf cups #{app_name}_service -p '{"type":"pricing", "url":"http://#{app_name}.cfapps.io"}'`
    ensure
      puts `cf logout`
    end
    puts "deployed"
  end

  desc "delete app from cloud foundry"
  task :delete, [:space, :prefix] do |t, args|
    space = args[:space]
    prefix = args[:prefix]
    app_name = "#{prefix}_pricing"
    db_name = "#{app_name}-db"

    puts "deleting..."
    begin
      puts `cf login -a api.run.pivotal.io -u #{ENV['CF_USERNAME']} -p #{ENV['CF_PASSWORD']} -o TW-org -s #{space}`
      puts `cf delete-service -f #{app_name}_service`
      puts `cf unbind-service #{app_name} #{db_name}`
      puts `cf delete-service -f #{db_name}`
      puts `cf delete -f #{app_name}`
    ensure
      puts `cf logout`
    end
    puts "deleted"
  end
end

task default: ['spec:unit']

