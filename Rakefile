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

desc "push to cloud foundry dev"
task :deploy_dev do
  sh "cf login -a api.run.pivotal.io -u #{ENV['CF_EMAIL']} -p #{ENV['CF_PASSWORD']} -o TW-org -s development"
  sh "cf push -n pretend-pricing-service-dev"
end

task default: [:spec]
