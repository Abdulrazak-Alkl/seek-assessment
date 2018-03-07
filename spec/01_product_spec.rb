require 'spec_helper'

describe 'product service' do

  before(:each) do
    @product_service = ProductService.new
  end

  it 'should create products' do
    @product_service.delete_all_products
    p1 = @product_service.create_product({sku: 'classic', name: 'Classic Ad', price: 269.99})
    expect(p1['sku']).to eq('classic')
    p2 = @product_service.create_product({sku: 'standout', name: 'Standout Ad', price: 322.99})
    expect(p2['sku']).to eq('standout')
    p3 = @product_service.create_product({sku: 'premium', name: 'Premium Ad', price: 394.99})
    expect(p3['sku']).to eq('premium')
  end

  it 'should get all products' do
    expect(@product_service.get_all_products.length).to eq(3)
  end

end