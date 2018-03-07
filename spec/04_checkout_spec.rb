require 'spec_helper'
describe 'checkout service' do

  before(:all) do
    @checkout_service = CheckoutService.new
    @checkout_service.delete_all_carts
    product_service = ProductService.new
    @classic_product = product_service.get_products_by(sku: 'classic')[0]
    @standout_product = product_service.get_products_by(sku: 'standout')[0]
    @premium_product = product_service.get_products_by(sku: 'premium')[0]
  end

  it 'should add 3 items to customer 0000 cart' do
    cart = @checkout_service.add_item(0000, @classic_product['sku'], @classic_product['price'])
    expect(cart['items'].length).to eq(1)
    cart = @checkout_service.add_item(0000, @standout_product['sku'], @standout_product['price'])
    expect(cart['items'].length).to eq(2)
    cart = @checkout_service.add_item(0000, @premium_product['sku'], @premium_product['price'])
    expect(cart['items'].length).to eq(3)
  end

  it 'should add 4 items to customer 1111 cart' do
    cart = @checkout_service.add_item(1111, @classic_product['sku'], @classic_product['price'])
    expect(cart['items'].length).to eq(1)
    cart = @checkout_service.add_item(1111, @classic_product['sku'], @classic_product['price'])
    expect(cart['items'].length).to eq(2)
    cart = @checkout_service.add_item(1111, @classic_product['sku'], @classic_product['price'])
    expect(cart['items'].length).to eq(3)
    cart = @checkout_service.add_item(1111, @premium_product['sku'], @premium_product['price'])
    expect(cart['items'].length).to eq(4)
  end

  it 'should add 4 items to customer 2222 cart' do
    cart = @checkout_service.add_item(2222, @standout_product['sku'], @standout_product['price'])
    expect(cart['items'].length).to eq(1)
    cart = @checkout_service.add_item(2222, @standout_product['sku'], @standout_product['price'])
    expect(cart['items'].length).to eq(2)
    cart = @checkout_service.add_item(2222, @standout_product['sku'], @standout_product['price'])
    expect(cart['items'].length).to eq(3)
    cart = @checkout_service.add_item(2222, @premium_product['sku'], @premium_product['price'])
    expect(cart['items'].length).to eq(4)
  end

  it 'should add 4 items to customer 3333 cart' do
    cart = @checkout_service.add_item(3333, @premium_product['sku'], @premium_product['price'])
    expect(cart['items'].length).to eq(1)
    cart = @checkout_service.add_item(3333, @premium_product['sku'], @premium_product['price'])
    expect(cart['items'].length).to eq(2)
    cart = @checkout_service.add_item(3333, @premium_product['sku'], @premium_product['price'])
    expect(cart['items'].length).to eq(3)
    cart = @checkout_service.add_item(3333, @premium_product['sku'], @premium_product['price'])
    expect(cart['items'].length).to eq(4)
  end

  it 'should not fetch any valid offers for customer 0000 and cart total after discount 987.97' do
    offers = @checkout_service.check_for_offers(0000)
    expect(offers.length).to eq(0)
    cart = @checkout_service.apply_offer(0000, nil)
    expect(cart['total']-cart['total_discount']).to eq(987.97)
  end

  it 'should fetch first valid offer for customer 1111 and apply it so cart total after discount is 934.97' do
    offers = @checkout_service.check_for_offers(1111)
    expect(offers.length).to eq(1)
    cart = @checkout_service.apply_offer(1111, offers[0]['id'])
    expect(cart['total']-cart['total_discount']).to eq(934.97)
  end

  it 'should fetch first valid offer for customer 2222 and apply it so cart total after discount is 1294.96' do
    offers = @checkout_service.check_for_offers(2222)
    expect(offers.length).to eq(1)
    cart = @checkout_service.apply_offer(2222, offers[0]['id'])
    expect(cart['total']-cart['total_discount']).to eq(1294.96)
  end

  it 'should fetch first valid offer for customer 3333 and apply it so cart total after discount is 1519.96' do
    offers = @checkout_service.check_for_offers(3333)
    expect(offers.length).to eq(1)
    cart = @checkout_service.apply_offer(3333, offers[0]['id'])
    expect(cart['total']-cart['total_discount']).to eq(1519.96)
  end

end