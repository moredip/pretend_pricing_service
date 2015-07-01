require 'rake'
require 'dotenv/tasks'

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
