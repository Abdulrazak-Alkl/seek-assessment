class CustomerService

  CUSTOMER_ATTRIBUTES = %w(id name)

  def get_all_customers
    guard { Customer.all.map &method(:to_serializable) }
  end

  def delete_all_customers
    guard { !!Customer.destroy_all }
  end

  def get_customer_by_id(id)
    guard { to_serializable Customer.find(id) }
  end

  def delete_customer_by_id(id)
    guard { !!Customer.destroy(id) }
  end

  def update_customer_by_id(id, customer_properties)
    guard do
      customer = Customer.find(id)
      customer.update!(customer_properties)
      to_serializable customer
    end
  end

  def create_customer(customer_properties)
    guard { to_serializable(Customer.create!(customer_properties)) }
  end

  private
  def to_serializable(customer_model)
    customer_model.serializable_hash.slice *CUSTOMER_ATTRIBUTES
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