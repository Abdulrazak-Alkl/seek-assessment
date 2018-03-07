class OfferService

  OFFER_ATTRIBUTES = %w(id price_rule_id customer_id usage_limit starts_at ends_at)

  def get_all_offers
    guard { Offer.all.map &method(:to_serializable) }
  end

  def delete_all_offers
    guard { !!Offer.destroy_all }
  end

  def get_offer_by_id(id)
    guard { to_serializable Offer.find(id) }
  end

  # TODO validate usage limit against the number of offers redeemed
  # num_of_redeems = Redis.current.get("#{customer_id:offer_id}")
  # num_of_redeems should be less than usage_limit
  def get_valid_offers(customer_id)
    guard { Offer.where(customer_id: customer_id)
              .where('starts_at <= ?', Time.now)
              .where('ends_at >= ?', Time.now)
              .all.map &method(:to_serializable) }
  end

  def delete_offer_by_id(id)
    guard { !!Offer.destroy(id) }
  end

  def update_offer_by_id(id, offer_properties)
    guard do
      offer = Offer.find(id)
      offer.update!(offer_properties)
      to_serializable offer
    end
  end

  def create_offer(offer_properties)
    guard { to_serializable(Offer.create!(offer_properties)) }
  end

  private
  def to_serializable(offer_model)
    offer_model.serializable_hash.slice *OFFER_ATTRIBUTES
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