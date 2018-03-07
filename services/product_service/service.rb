class ProductService

  PRODUCT_ATTRIBUTES = %w(sku name price)

  def get_all_products
    guard { Product.all.map &method(:to_serializable) }
  end
  
  def delete_all_products
    guard { !!Product.destroy_all }
  end

  def get_product_by_id(id)
    guard { to_serializable Product.find(id) }
  end

  def get_products_by(where_clause)
    guard { Product.where(where_clause).all.map &method(:to_serializable) }
  end

  def delete_product_by_id(id)
    guard { !!Product.destroy(id) }
  end

  def update_product_by_id(id, product_properties)
    guard do
      product = Product.find(id)
      product.update!(product_properties)
      to_serializable product
    end
  end

  def create_product(product_properties)
    guard { to_serializable(Product.create!(product_properties)) }
  end

  private
  def to_serializable(product_model)
    product_model.serializable_hash.slice *PRODUCT_ATTRIBUTES
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