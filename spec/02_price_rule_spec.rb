require 'spec_helper'

describe 'price rule service' do

  before(:all) do
    @price_rule_service = PriceRuleService.new
  end

  it 'should create price rules' do
    @price_rule_service.delete_all_price_rules

    pr1 = @price_rule_service.create_price_rule({
                                                 id: 1111,
                                                 title: '3 for 2 deals on Classic Ads',
                                                 value_type: ENTITLEMENTS::FREEBIES,
                                                 value: 1,
                                                 prerequisite_minimum_items: 3,
                                                 entitled_products_skus: %w(classic)
                                               })
    expect(pr1['id']).to eq(1111)
    expect(@price_rule_service.get_price_rule_by_id(pr1['id'])['id']).to eq(1111)
    pr2 = @price_rule_service.create_price_rule({
                                                 id: 2222,
                                                 title: 'Discount on Standout Ads where the price drops to $299.99 per ad',
                                                 value_type: ENTITLEMENTS::FIXED_PRICE,
                                                 value: 299.99,
                                                 target_selection: TARGETS::ENTITLED,
                                                 allocation_method: ALLOCATIONS::EACH,
                                                 prerequisite_minimum_items: 1,
                                                 entitled_products_skus: %w(standout)
                                               })
    expect(pr2['id']).to eq(2222)
    expect(@price_rule_service.get_price_rule_by_id(pr2['id'])['id']).to eq(2222)
    pr3 = @price_rule_service.create_price_rule({
                                                 id: 3333,
                                                 title: 'Discount on Premium Ads where 4 or more are purchased. The price
drops to $379.99 per ad',
                                                 value_type: ENTITLEMENTS::FIXED_PRICE,
                                                 value: 379.99,
                                                 target_selection: TARGETS::ENTITLED,
                                                 allocation_method: ALLOCATIONS::EACH,
                                                 prerequisite_minimum_items: 4,
                                                 entitled_products_skus: %w(premium)
                                               })
    expect(pr3['id']).to eq(3333)
    expect(@price_rule_service.get_price_rule_by_id(pr3['id'])['id']).to eq(3333)
    pr4 = @price_rule_service.create_price_rule({
                                                 id: 4444,
                                                 title: '5 for 4 deal on Classic Ads',
                                                 value_type: ENTITLEMENTS::FREEBIES,
                                                 value: 1,
                                                 prerequisite_minimum_items: 5,
                                                 entitled_products_skus: %w(classic)
                                               })
    expect(pr4['id']).to eq(4444)
    expect(@price_rule_service.get_price_rule_by_id(pr4['id'])['id']).to eq(4444)
    pr5 = @price_rule_service.create_price_rule({
                                                 id: 5555,
                                                 title: 'Discount on Standout Ads where the price drops to $309.99 per ad',
                                                 value_type: ENTITLEMENTS::FIXED_PRICE,
                                                 value: 309.99,
                                                 target_selection: TARGETS::ENTITLED,
                                                 allocation_method: ALLOCATIONS::EACH,
                                                 prerequisite_minimum_items: 1,
                                                 entitled_products_skus: %w(standout)
                                               })
    expect(pr5['id']).to eq(5555)
    expect(@price_rule_service.get_price_rule_by_id(pr5['id'])['id']).to eq(5555)
    pr6 = @price_rule_service.create_price_rule({
                                                 id: 6666,
                                                 title: 'Discount on Premium Ads when 3 or more are purchased. The price
drops to $389.99 per ad',
                                                 value_type: ENTITLEMENTS::FIXED_PRICE,
                                                 value: 389.99,
                                                 target_selection: TARGETS::ENTITLED,
                                                 allocation_method: ALLOCATIONS::EACH,
                                                 prerequisite_minimum_items: 3,
                                                 entitled_products_skus: %w(premium)
                                               })
    expect(pr6['id']).to eq(6666)
    expect(@price_rule_service.get_price_rule_by_id(pr6['id'])['id']).to eq(6666)
  end

  it 'should get all price rules' do
    expect(@price_rule_service.get_all_price_rules.length).to eq(6)
  end

end