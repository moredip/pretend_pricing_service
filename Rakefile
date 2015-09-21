require 'rake'
require 'dotenv/tasks'
require 'securerandom'
require "sequel"
require 'json'

namespace :spec do
  begin
    require 'rspec/core'
    require 'rspec/core/rake_task'

    RSpec::Core::RakeTask.new(:unit) do |spec|
      spec.pattern = FileList['spec/unit/*_spec.rb']
    end

    RSpec::Core::RakeTask.new(:run_functional) do |spec|
      spec.pattern = FileList['spec/functional/*_spec.rb']
    end

    desc "run functional tests against a deployed service"
    task :functional => :dotenv do
      app_name = "pretend-pricing-service-#{SecureRandom.hex(4)}"
      ENV['APP_NAME'] = app_name
      Rake::Task["app:deploy"].invoke(ENV['RACK_ENV'], app_name, app_name)
      Rake::Task["spec:run_functional"].invoke()
      Rake::Task["app:delete"].invoke(ENV['RACK_ENV'], app_name)
    end
  rescue LoadError
  end
end

desc "run local server"
task :server do
  exec "foreman start"
end

def migrate(db_url, version=nil)
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

namespace :db do
  desc "Run migrations"
  task :migrate, [:version] => :dotenv do |t, args|
    migrate(ENV.fetch("DATABASE_URL"), args[:version])
  end
end

namespace :app do
  desc "push to cloud foundry"
  task :deploy, [:space, :app_name, :host] do |t, args|
    sh "cf login -a api.run.pivotal.io -u #{ENV['CF_EMAIL']} -p #{ENV['CF_PASSWORD']} -o TW-org -s #{args[:space]}"
    app_name = args[:app_name]
    db_name = "#{app_name}-db"
    db_key_name = "#{db_name}_key"
    sh "cf create-service elephantsql turtle #{db_name}"
    sh "cf create-service-key #{db_name} #{db_key_name}"
    cf_stdout = `cf service-key #{db_name} #{db_key_name}`
    key_json = cf_stdout.slice(cf_stdout.index('{')..-1)
    db_url = JSON.parse(key_json)["uri"]
    sh "cf push #{app_name} -n #{args[:host]} --no-start"
    sh "cf set-env #{app_name} DATABASE_URL #{db_url}"
    migrate(db_url)
    sh "cf start #{app_name}"
  end

  desc "delete app from cloud foundry"
  task :delete, [:space, :app_name] do |t, args|
    sh "cf login -a api.run.pivotal.io -u #{ENV['CF_EMAIL']} -p #{ENV['CF_PASSWORD']} -o TW-org -s #{args[:space]}"
    db_name = "#{args[:app_name]}-db"
    db_key_name = "#{db_name}_key"
    sh "cf delete-service-key -f #{db_name} #{db_key_name}"
    sh "cf delete-service -f #{db_name}"
    sh "cf delete -f #{args[:app_name]}"
  end
end

task default: ['spec:unit']

