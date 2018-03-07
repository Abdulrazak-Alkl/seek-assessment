require 'active_record'
require 'active_model'
require 'active_support'
require 'yaml'

Dir['services/*/models/*.rb'].each {|file| require_relative file }
Dir['services/*/service.rb'].each {|file| require_relative file }

DB_CONFIG = YAML.load_file("#{File.dirname(__FILE__)}/config/database.yml")[ENV['ENV'] || 'development']
ActiveRecord::Base.establish_connection DB_CONFIG
