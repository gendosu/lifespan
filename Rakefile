require "bundler/gem_tasks"
require 'rubygems'

require 'rspec/core'
require 'rspec/core/rake_task'

require 'active_record'
require 'mysql2'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

namespace :lifespan do
  namespace :db do
    task :rails_env do
      unless defined? RAILS_ENV
        RAILS_ENV = ENV['RAILS_ENV'] ||= 'test'
      end
    end

    task :load_config => :rails_env do
      yaml_file = File.join(File.dirname(__FILE__), 'spec/config/database.yml')
      ActiveRecord::Base.configurations = YAML.load ERB.new(IO.read(yaml_file)).result
    end

    desc "create test database"
    task :create => :load_config do
      ActiveRecord::Tasks::DatabaseTasks.create_current(RAILS_ENV)
    end

    desc "drop test database"
    task :drop => :load_config do
      ActiveRecord::Tasks::DatabaseTasks.drop_current(RAILS_ENV)
    end
  end
end

namespace :test do
  desc 'for travis ci'
  task :travis do
    ["rake spec"].each do |cmd|
      puts "Starting to run #{cmd}..."
      system("export DISPLAY=:99.0 && bundle exec #{cmd}")
      raise "#{cmd} failed!" unless $?.exitstatus == 0
    end
  end
end

task default: :spec
