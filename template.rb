# Setup database
file 'config/database.yml', <<-CODE
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  url: <%= ENV.fetch("DATABASE_URL") { "postgres://postgres@postgres:5432/app" } %>
  timeout: 5000

development:
  <<: *default

test:
  <<: *default

production:
  <<: *default
CODE

after_bundle do
  # Prepare database
  rails_command "db:prepare"
end