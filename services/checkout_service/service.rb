class CheckoutService

  CART_ATTRIBUTES = %w(customer_id items total total_discount)

  def add_item(customer_id, product_sku, product_price)
    cart = Cart.find_or_create_by(customer_id: customer_id)
    cart.items ||= []
    cart.items << {sku: product_sku, price: product_price}
    cart.total += product_price
    guard do
      cart.save!
      to_serializable cart
    end
  end

  # TODO find better way to maintain input validation (cart existence for passed customer)
  def check_for_offers(customer_id)
    valid_offers = []
    # Get customer cart
    cart = Cart.find_by(customer_id: customer_id)
    if cart
      # init services
      offer_service = OfferService.new
      price_rule_service = PriceRuleService.new
      # call offer service to get all valid customer's offers
      offer_service.get_valid_offers(customer_id).each do |offer|
        # call price rule service for each offer to validate which offer apply to the items in the cart
        valid_offers << offer if price_rule_service.price_rule_valid?(offer['price_rule_id'], cart.items)
      end
    end
    valid_offers
  end

  # TODO find better way to maintain input validation (cart and offer existence for passed customer and offer)
  def apply_offer(customer_id, offer_id)
    cart = Cart.find_by(customer_id: customer_id)
    if cart
      offer_service = OfferService.new
      offer = offer_service.get_offer_by_id(offer_id)
      unless offer[:error]
        price_rule_service = PriceRuleService.new
        total_discount, items = price_rule_service.evaluate_price_rule(offer['price_rule_id'], cart.items)
        return guard do
          cart.update!(total_discount: total_discount, items: items)
          to_serializable cart
        end
      end
    end
    guard { to_serializable cart }
  end

  def delete_all_carts
    guard { !!Cart.destroy_all }
  end

  private
  def to_serializable(customer_model)
    customer_model.serializable_hash.slice *CART_ATTRIBUTES
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

end