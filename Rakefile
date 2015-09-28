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
    db_url = ENV.fetch("DATABASE_URL")
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
  task :deploy, [:space, :app_name, :host] do |t, args|
    space = args[:space]
    app_name = args[:app_name]
    host = args[:host]
    db_name = "#{app_name}-db"
    db_key_name = "#{db_name}_key"

    puts "deploying..."
    begin
      puts `cf login -a api.run.pivotal.io -u #{ENV['CF_USERNAME']} -p #{ENV['CF_PASSWORD']} -o TW-org -s #{space}`
      puts `cf create-service elephantsql turtle #{db_name}`
      puts `cf create-service-key #{db_name} #{db_key_name}`

      cf_stdout = `cf service-key #{db_name} #{db_key_name}`
      key_json = cf_stdout.slice(cf_stdout.index('{')..-1)
      db_url = JSON.parse(key_json)["uri"]

      puts `cf push #{app_name} -n #{host} --no-start`
      `cf set-env #{app_name} DATABASE_URL #{db_url} > /dev/null 2>&1`
      puts `cf push #{app_name} -n #{host} -c 'bundle exec rake db:migrate && bundle exec puma -C puma.rb'`
    ensure
      puts `cf logout`
    end
    puts "deployed"
  end

  desc "delete app from cloud foundry"
  task :delete, [:space, :app_name] do |t, args|
    space = args[:space]
    app_name = args[:app_name]
    db_name = "#{args[:app_name]}-db"
    db_key_name = "#{db_name}_key"

    puts "deleting..."
    begin
      puts `cf login -a api.run.pivotal.io -u #{ENV['CF_USERNAME']} -p #{ENV['CF_PASSWORD']} -o TW-org -s #{space}`
      puts `cf delete-service-key -f #{db_name} #{db_key_name}`
      puts `cf delete-service -f #{db_name}`
      puts `cf delete -f #{app_name}`
    ensure
      puts `cf logout`
    end
    puts "deleted"
  end
end

task default: ['spec:unit']

