require 'spec_helper'
describe 'checkout service' do

  before(:each) do
    @checkout_service = CheckoutService.new
    product_service = ProductService.new
    @classic_product = product_service.get_products_by(sku: 'classic')[0]
    @standout_product = product_service.get_products_by(sku: 'standout')[0]
    @premium_product = product_service.get_products_by(sku: 'premium')[0]
  end

  it 'should add items to cart' do
    @checkout_service.delete_all_carts

    cart = @checkout_service.add_item(0000, @classic_product['sku'], @classic_product['price'])
    expect(cart['items'].length).to eq(1)
    cart = @checkout_service.add_item(0000, @standout_product['sku'], @standout_product['price'])
    expect(cart['items'].length).to eq(2)
    cart = @checkout_service.add_item(0000, @premium_product['sku'], @premium_product['price'])
    expect(cart['items'].length).to eq(3)

    cart = @checkout_service.add_item(1111, @classic_product['sku'], @classic_product['price'])
    expect(cart['items'].length).to eq(1)
    cart = @checkout_service.add_item(1111, @classic_product['sku'], @classic_product['price'])
    expect(cart['items'].length).to eq(2)
    cart = @checkout_service.add_item(1111, @classic_product['sku'], @classic_product['price'])
    expect(cart['items'].length).to eq(3)
    cart = @checkout_service.add_item(1111, @premium_product['sku'], @premium_product['price'])
    expect(cart['items'].length).to eq(4)

    cart = @checkout_service.add_item(2222, @standout_product['sku'], @standout_product['price'])
    expect(cart['items'].length).to eq(1)
    cart = @checkout_service.add_item(2222, @standout_product['sku'], @standout_product['price'])
    expect(cart['items'].length).to eq(2)
    cart = @checkout_service.add_item(2222, @standout_product['sku'], @standout_product['price'])
    expect(cart['items'].length).to eq(3)
    cart = @checkout_service.add_item(2222, @premium_product['sku'], @premium_product['price'])
    expect(cart['items'].length).to eq(4)

    cart = @checkout_service.add_item(3333, @premium_product['sku'], @premium_product['price'])
    expect(cart['items'].length).to eq(1)
    cart = @checkout_service.add_item(3333, @premium_product['sku'], @premium_product['price'])
    expect(cart['items'].length).to eq(2)
    cart = @checkout_service.add_item(3333, @premium_product['sku'], @premium_product['price'])
    expect(cart['items'].length).to eq(3)
    cart = @checkout_service.add_item(3333, @premium_product['sku'], @premium_product['price'])
    expect(cart['items'].length).to eq(4)
  end

  it 'should fetch valid offers for the current items in the cart and apply first one' do
    offers = @checkout_service.check_for_offers(0000)
    expect(offers.length).to eq(0)
    cart = @checkout_service.apply_offer(0000, nil)
    expect(cart['total']-cart['total_discount']).to eq(987.97)

    offers = @checkout_service.check_for_offers(1111)
    expect(offers.length).to eq(1)
    cart = @checkout_service.apply_offer(1111, offers[0]['id'])
    expect(cart['total']-cart['total_discount']).to eq(934.97)

    offers = @checkout_service.check_for_offers(2222)
    expect(offers.length).to eq(1)
    cart = @checkout_service.apply_offer(2222, offers[0]['id'])
    expect(cart['total']-cart['total_discount']).to eq(1294.96)

    offers = @checkout_service.check_for_offers(3333)
    expect(offers.length).to eq(1)
    cart = @checkout_service.apply_offer(3333, offers[0]['id'])
    expect(cart['total']-cart['total_discount']).to eq(1519.96)
  end

end