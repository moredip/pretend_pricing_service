setup = {
  env:          ENV['RACK_ENV']         || 'development',
  port:        (ENV['PORT']             || 9292).to_i,
  min_threads: (ENV['PUMA_MIN_THREADS'] || 10).to_i,
  max_threads: (ENV['PUMA_MAX_THREADS'] || 10).to_i,
  workers:     (ENV['PUMA_WORKERS']     || 2).to_i
}

port        ENV.fetch('PORT',9292).to_i
environment ENV.fetch('RACK_ENV','development')
workers     ENV.fetch('PUMA_WORKERS',2).to_i
threads     ENV.fetch('PUMA_MIN_THREADS',10).to_i, ENV.fetch('PUMA_MAX_THREADS',10).to_i

preload_app!

on_worker_boot do
  # Disconnect the Sequel connection pool so new connections are created.
  DB.disconnect
end
