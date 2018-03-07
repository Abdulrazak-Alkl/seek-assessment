require 'spec_helper'

describe 'customer service' do

  before(:all) do
    @customer_service = CustomerService.new
  end

  it 'should create customers' do
    @customer_service.delete_all_customers
    c0 = @customer_service.create_customer({id: 0000, name: 'default'})
    expect(c0['id']).to eq(0000)
    c1 = @customer_service.create_customer({id: 1111, name: 'Unilever'})
    expect(c1['id']).to eq(1111)
    c2 = @customer_service.create_customer({id: 2222, name: 'Apple'})
    expect(c2['id']).to eq(2222)
    c3 = @customer_service.create_customer({id: 3333, name: 'Nike'})
    expect(c3['id']).to eq(3333)
    c4 = @customer_service.create_customer({id: 4444, name: 'Ford'})
    expect(c4['id']).to eq(4444)
  end

  it 'should get all customers' do
    expect(@customer_service.get_all_customers.length).to eq(5)
  end

end