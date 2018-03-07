require 'spec_helper'

describe 'offer service' do

  before(:all) do
    @offer_service = OfferService.new
  end

  it 'should create offers and assign to customers' do

    @offer_service.delete_all_offers

    @offer_service.create_offer({
                                  usage_limit: 1,
                                  customer_id: 1111,
                                  price_rule_id: 1111,
                                  starts_at: '2018-01-01T00:00:00',
                                  ends_at: '2018-12-31T23:59:59'
                                })

    @offer_service.create_offer({
                                  usage_limit: 1,
                                  customer_id: 2222,
                                  price_rule_id: 2222,
                                  starts_at: '2018-01-01T00:00:00',
                                  ends_at: '2018-12-31T23:59:59'
                                })

    @offer_service.create_offer({
                                  usage_limit: 1,
                                  customer_id: 3333,
                                  price_rule_id: 3333,
                                  starts_at: '2018-01-01T00:00:00',
                                  ends_at: '2018-12-31T23:59:59'
                                })

    @offer_service.create_offer({
                                  usage_limit: 1,
                                  customer_id: 4444,
                                  price_rule_id: 4444,
                                  starts_at: '2018-01-01T00:00:00',
                                  ends_at: '2018-12-31T23:59:59'
                                })

    @offer_service.create_offer({
                                  usage_limit: 1,
                                  customer_id: 4444,
                                  price_rule_id: 5555,
                                  starts_at: '2018-01-01T00:00:00',
                                  ends_at: '2018-12-31T23:59:59'
                                })

    @offer_service.create_offer({
                                  usage_limit: 1,
                                  customer_id: 4444,
                                  price_rule_id: 6666,
                                  starts_at: '2018-01-01T00:00:00',
                                  ends_at: '2018-12-31T23:59:59'
                                })

  end

  it 'should get all offers' do
    expect(@offer_service.get_all_offers.length).to eq(6)
  end

  it 'should get all valid offers for customer_id 4444' do
    expect(@offer_service.get_valid_offers(4444).length).to eq(3)
  end

end