class Cart < ActiveRecord::Base
  serialize :items
end