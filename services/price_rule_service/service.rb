class PriceRuleService

  PRICE_RULE_ATTRIBUTES = %w(id title value_type value target_selection allocation_method prerequisite_minimum_items prerequisite_minimum_subtotal entitled_products_skus)

  #
  # Validate the cart items against the price rule
  #
  # @param price_rule_id [Integer]
  # @param items         [Array]
  #
  # Example of items param:
  # [{sku: 'classic', price: 213.99},{sku: 'standout', price: 322.99}]
  #
  # @return [Array[Integer, Array]]
  #
  # Example of return value :
  # [total_discount, items_with_discount]
  # [200, [{sku: 'classic', price: 213.99, discount: 100},{sku: 'standout', price: 322.99, discount: 100}] ]]
  #
  def evaluate_price_rule(price_rule_id, items)
    price_rule = PriceRule.find(price_rule_id)
    total_discount = 0
    case price_rule.value_type
      when ENTITLEMENTS::FIXED_PRICE
        total_discount, items = resolve_rule(price_rule, items) { |amount, rule_value| amount - rule_value }
      when ENTITLEMENTS::FREEBIES
        total_discount = price_rule.value * lowest_item_price(items)
      when ENTITLEMENTS::FIXED_AMOUNT_DISCOUNT
        total_discount, items = resolve_rule(price_rule, items) { |amount, rule_value| rule_value }
      when ENTITLEMENTS::FIXED_PERCENTAGE_DISCOUNT
        total_discount, items = resolve_rule(price_rule, items) { |amount, rule_value| (amount * rule_value)/100 }
      else
        total_discount = 0
    end
    [total_discount, items]
  end

  #
  # Validate the cart items against the price rule
  #
  # @param price_rule_id [Integer]
  # @param items         [Array]
  #
  # Example of items param:
  # [{sku: 'classic', price: 213.99},{sku: 'standout', price: 322.99}]
  #
  # @return [Boolean]
  #
  def price_rule_valid?(price_rule_id, items)
    # Fetch price rule
    price_rule = PriceRule.find(price_rule_id)
    # validate that the cart items belong to the price rule entitled products
    price_rule.entitled_products_skus.each do |entitled|
      return false unless items.map{|i| i['sku']}.include?(entitled)
    end
    # validate that the total/number.of.items of cart is greater than or equal to the minimum prerequisite
    if price_rule.prerequisite_minimum_subtotal
      total = 0
      items.each{|i| total += i['price']}
      return false unless total >= price_rule.prerequisite_minimum_subtotal
    elsif price_rule.prerequisite_minimum_items
      return false unless items.select{|i| price_rule.entitled_products_skus.include?(i['sku'])}.size >= price_rule.prerequisite_minimum_items
    end
    true
  end

  def get_all_price_rules
    guard { PriceRule.all.map &method(:to_serializable) }
  end

  def delete_all_price_rules
    guard { !!PriceRule.destroy_all }
  end

  def get_price_rule_by_id(id)
    guard { to_serializable PriceRule.find(id) }
  end

  def delete_price_rule_by_id(id)
    guard { !!PriceRule.destroy(id) }
  end

  def update_price_rule_by_id(id, price_rule_properties)
    guard do
      price_rule = PriceRule.find(id)
      price_rule.update!(price_rule_properties)
      to_serializable price_rule
    end
  end

  def create_price_rule(price_rule_properties)
    guard { to_serializable(PriceRule.create!(price_rule_properties)) }
  end

  private
  def to_serializable(price_rule_model)
    price_rule_model.serializable_hash.slice *PRICE_RULE_ATTRIBUTES
  end

  def guard
    ActiveRecord::Base.connection_pool.with_connection do
      begin
        yield
      rescue ActiveRecord::RecordNotFound => e
        { error: {code: 101, message: e.message} }
      rescue ActiveRecord::RecordInvalid => e
        { error: {code: 100, message: e.message} }
      end
    end
  end

  def resolve_rule(price_rule, items)
    total_discount = 0
    if price_rule.allocation_method == ALLOCATIONS::EACH
      if price_rule.target_selection == TARGETS::ENTITLED
        items.each do |i|
          if price_rule.entitled_products_skus.include?(i['sku'])
            i['discount'] = yield(i['price'], price_rule.value)
            total_discount += i['discount']
          end
        end
      elsif price_rule.target_selection == TARGETS::ALL
        items.each do |i|
          i['discount'] = yield(i['price'], price_rule.value)
          total_discount += i['discount']
        end
      end
    elsif price_rule.allocation_method == ALLOCATIONS::ACROSS
      total = 0
      items.each{|i| total += i['price']}
      total_discount = yield(total, price_rule.value)
    end
    [total_discount, items]
  end

  def lowest_item_price(items)
    items.map{|i| i['price']}.min
  end

end