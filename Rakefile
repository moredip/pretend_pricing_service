require 'rake'
require 'dotenv/tasks'
require 'securerandom'
require "sequel"
require 'json'
require 'cloudfoundry/deploy'

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

task default: ['spec:unit']

