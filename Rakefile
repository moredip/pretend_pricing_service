require 'rake'
require 'dotenv/tasks'
require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/api/*_spec.rb']
end

desc "run local server"
task :server do
  exec "foreman start"
end

namespace :db do
  desc "Run migrations"
  task :migrate, [:version] => :dotenv do |t, args|

    require "sequel"
    Sequel.extension :migration
    db = Sequel.connect(ENV.fetch("DATABASE_URL"))
    if args[:version]
      puts "Migrating to version #{args[:version]}"
      Sequel::Migrator.run(db, "db_migrations", target: args[:version].to_i)
    else
      puts "Migrating to latest"
      Sequel::Migrator.run(db, "db_migrations")
    end
  end
end

desc "push to cloud foundry"
task :deploy, [:space, :host] do |t, args|
  require 'json'
  sh "cf login -a api.run.pivotal.io -u #{ENV['CF_EMAIL']} -p #{ENV['CF_PASSWORD']} -o TW-org -s #{args[:space]}"
  sh "cf create-service elephantsql turtle pricing_db"
  sh "cf create-service-key pricing_db pricing_db_key"
  cf_stdout = `cf service-key pricing_db pricing_db_key`
  key_json = cf_stdout.slice(cf_stdout.index('{')..-1)
  puts key_json
  db_url = JSON.parse(key_json)["uri"]
  sh "cf push -n #{args[:host]} --no-start"
  sh "cf set-env pretend-pricing-service DATABASE_URL #{db_url}"
  sh "cf start pretend-pricing-service"
end

desc "delete app from cloud foundry"
task :delete_app, [:space] do |t, args|
  sh "cf login -a api.run.pivotal.io -u #{ENV['CF_EMAIL']} -p #{ENV['CF_PASSWORD']} -o TW-org -s #{args[:space]}"
  sh "cf delete-service-key -f pricing_db pricing_db_key"
  sh "cf delete-service -f pricing_db"
  sh "cf delete -f pretend-pricing-service"
end

task default: [:spec]
