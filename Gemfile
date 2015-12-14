source "https://rubygems.org"

gemspec

git 'https://github.com/refinery/refinerycms.git', branch: 'master' do
  gem 'refinerycms'

  group :development, :test do
    gem 'refinerycms-testing'
  end
end

unless ENV["TRAVIS"]
  gem "activerecord-jdbcsqlite3-adapter", platform: :jruby
  gem "sqlite3", platform: :ruby
end

if !ENV["TRAVIS"] || ENV["DB"] == "mysql"
  gem "activerecord-jdbcmysql-adapter", platform: :jruby
  gem "jdbc-mysql", "= 5.1.13", platform: :jruby
  gem "mysql2", platform: :ruby
end

if !ENV["TRAVIS"] || ENV["DB"] == "postgresql"
  gem "activerecord-jdbcpostgresql-adapter", platform: :jruby
  gem "pg", platform: :ruby
end

gem 'refinerycms-page-images',
  git: 'https://github.com/refinery/refinerycms-page-images',
  branch: 'master'


gem 'refinerycms-wymeditor',
  git: 'https://github.com/parndt/refinerycms-wymeditor',
  branch: 'master'

# Database Configuration
platforms :jruby do
  gem 'jruby-openssl'
end

group :development, :test do
  platforms :ruby do
    require 'rbconfig'
    if RbConfig::CONFIG['target_os'] =~ /linux/i
      gem 'therubyracer', '~> 0.11.4'
    end
  end
end

group :test do
  gem "launchy"
  gem 'rspec-its' # for the model's validation tests.
end
# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end
