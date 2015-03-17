$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'lifespan'
require 'delorean'

require 'active_support/dependencies/autoload'

def load_schema
  # TODO
  #   Rails 4.2でMySQL5.6でミリ秒未対応カラムを使っている場合、エラーが発生するので以下のファイルを読む必要がある
  #   だが、Rails4.2以外では読みたくない。
  Dir["#{File.dirname(__FILE__)}/config/initializers/**/*.rb"].sort.each do |initializer|
    load(initializer)
  end

  config = YAML::load(IO.read('spec/config/database.yml'))
  ActiveRecord::Base.configurations = config
  ActiveRecord::Base.establish_connection(:test)
  ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/test.log")
  require File.dirname(__FILE__) + "/database.rb"
end

RSpec.configure do |config|
  config.include Delorean

  config.after(:each) do
    load_schema
  end
end

# example model classes
Dir["spec/models/*.rb"].sort.each { |f| require File.expand_path(f) }
