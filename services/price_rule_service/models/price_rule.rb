class PriceRule < ActiveRecord::Base
  serialize :entitled_products_skus
end

module ENTITLEMENTS
  FREEBIES = 'freebies'
  FIXED_PERCENTAGE_DISCOUNT = 'percentage_discount'
  FIXED_AMOUNT_DISCOUNT = 'amount_discount'
  FIXED_PRICE = 'fixed_price'
end

module TARGETS
  ALL = 'all'
  ENTITLED = 'entitled'
end

module ALLOCATIONS
  EACH = 'each'
  ACROSS = 'across'
end