# encoding: utf-8
# == Schema Information
#
# Table name: carts
#
#  id                          :integer          not null, primary key
#  user_id                     :integer
#  client_id                   :integer
#  communication_failed        :boolean          default(FALSE)
#  status_text                 :string(255)
#  store_id                    :integer
#  store_order_id              :string(255)
#  service_method              :string(255)
#  business_date               :datetime
#  advance_order_time          :datetime
#  net_amount                  :decimal(, )
#  tax_amount                  :decimal(, )
#  tax1_amount                 :decimal(, )
#  tax2_amount                 :decimal(, )
#  payment_amount              :decimal(, )
#  message                     :string(255)
#  order_text                  :string(255)
#  order_progress              :string(255)
#  can_place_order             :boolean
#  delivery_instructions       :text
#  payment_type                :string(255)
#  credit_cart_approval_number :string(255)
#  fiscal_number               :string(255)
#  fiscal_type                 :string(255)
#  company_name                :string(255)
#  discount                    :decimal(, )
#  discount_auth_id            :integer
#  completed                   :boolean          default(FALSE)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  message_mask                :integer
#  reason_id                   :integer
#  complete_on                 :datetime
#  placed_at                   :datetime
#  exonerated                  :boolean
#  started_on                  :datetime
#  exoneration_authorizer      :integer
#  creditcard_number           :string(255)
#  fiscal_company_name         :string(255)
#

require 'spec_helper'

describe Cart do
  context 'Validation' do
    it { should validate_presence_of :user_id }
    it { should belong_to :user }
    it { should belong_to :client }
    it { should belong_to :store }
    it { should have_many :cart_coupons }
    it { should have_many(:coupons).through(:cart_coupons) }
    it { should have_many :cart_products }
    it { should have_many(:products).through(:cart_products) }
  end


  describe 'mailboxes' do

    let!(:cart) { FactoryGirl.create :cart }
    subject { cart.mailboxes }

    it "should return the available mailboxes" do
      Cart.valid_mailboxes.should include('nuevos', 'archivados', 'eliminados', 'criticos')
    end

    it "should return nuevos if the cart if new" do
      should include('nuevos')
    end

    it "should move to archivados" do
      cart.archive!
      should_not include('nuevos')
      should include('archivados')
    end

    it "should move to eliminados" do
      cart.trash!
      should_not include('nuevos')
      should include('eliminados')
    end

    it "should mark as criticos" do
      cart.critical!
      should include('nuevos')
      should include('criticos')
    end

  end

  describe '#perform_discount' do
    let!(:admin) { create :user, username: 'test_admin', password: 'please', password_confirmation: 'please', roles: [ 'admin' ] }
    let!(:operator) { create :user, username: 'tester', password: 'please', password_confirmation: 'please', roles: [ 'operator' ] }
    let!(:cart){ create :cart, net_amount: 100, tax_amount: 45, tax1_amount: 20, tax2_amount: 15, payment_amount: 145 }
    let!(:cart_product){ create :cart_product , priced_at: 1000, cart: cart }

    it 'should allow a discount if the user is and authenticated admin' do
      cart.perform_discount(admin.username, 'please', 40.0)
      cart.reload
      cart.payment_amount.round.should == 145.0
      cart.discount.should == 40
      cart.discount_auth_id.should == admin.id
    end

    it 'should allow not allow discount if the discount if the en payment_amount if less or equal zero' do
      cart.perform_discount(admin.username, 'please', 400.0).should be_false
      cart.errors.full_messages.should include('El el monto a descontar no es valido')
    end

    it 'should allow not allow discount if the username is not found' do
      cart.perform_discount('tester', 'please', 400.0).should be_false
      cart.errors.full_messages.should include('El usuario provisto no tiene suficientes provilegios')
    end

  end

  describe '#exonerate' do
    let!(:admin) { create :user, username: 'test_admin', password: 'please', password_confirmation: 'please', roles: [ 'admin' ] }
    let!(:operator) { create :user, username: 'tester', password: 'please', password_confirmation: 'please', roles: [ 'operator' ] }
    let!(:cart){ create :cart, net_amount: 100, tax_amount: 45, tax1_amount: 20, tax2_amount: 15, payment_amount: 145 }
    let!(:cart_product){ create :cart_product , priced_at: 1000, cart: cart }

    it 'should allow a discount if the user is and authenticated admin' do
      cart.exonerate(admin.username, 'please')
      cart.reload
      cart.should be_exonerated
      cart.exoneration_authorizer.should == admin.id
    end

    it 'should allow not allow exoneration if the username is not found' do
      cart.exonerate('tester', 'please').should be_false
      cart.errors.full_messages.should include('El usuario provisto no tiene suficientes provilegios')
    end

  end

  describe '#clear_client' do

    let!(:client) { create :client }
    let!(:user) { create :user, :operator }
    let!(:cart) { create :cart, client: client, user: user }

    it "should reset value to nil or zero " do
      cart.client.should == client
      cart.clear_client!
      cart.reload
      cart.client.should be_nil
      cart.user.should == user
    end

  end

  describe '#clear_service_method!' do
    let!(:user){ create :user, :operator }
    let!(:cart){ create :cart, user: user, service_method: 'PickUp'}

    it "should reset value to nil or zero " do
      cart.service_method.should == 'PickUp'
      cart.clear_service_method!
      cart.reload
      cart.service_method.should be_nil
      cart.user.should == user
    end

  end

  describe '#reset_for_new_client!' do
    let!(:client){ create :client }
    let!(:user){ create :user, :operator }
    let!(:store){ create :store }
    let!(:cart){ create :cart, client: client, payment_amount: 100.00, service_method: 'PickUp', store: store, user: user}

    it "should reset value to nil or zero " do
      cart.client.should == client
      cart.payment_amount.should == 100.00
      cart.service_method.should == 'PickUp'
      cart.store.should == store
      cart.reset_for_new_client!
      cart.reload
      cart.payment_amount.should be_nil
      cart.service_method.should be_nil
      cart.store.should be_nil
      cart.client.should == client
      cart.user.should == user
    end

  end

  describe '.service_methods' do
    it "should return the list of pulse service_methods " do
      Cart.service_methods.should == %w( delivery pickup dinein )
    end
  end

  describe '#clear_discount' do
    let!(:user){ create :user, :operator }
    let!(:admin){ create :user, :admin }
    let!(:cart){ create :cart, user: user, discount: 100 , discount_auth_id: admin.id }

    it "should reset value to nil or zero " do
      cart.discount.should == 100
      cart.clear_discount!
      cart.reload
      cart.discount.should be_nil
      cart.discount_auth_id.should be_nil
      cart.user.should == user
    end

  end

  describe '#placeable?' do
    let!(:cart_product) { create :cart_product }
    let!(:cart) { cart_product.cart }

    it 'should return true if all requirements are met' do
      cart.should be_placeable
    end

    it 'should not be placeable if store is missing' do
      cart.store = nil
      cart.should_not be_placeable
    end

    it 'should not be placeable if it has no products' do
      cart.cart_products.each { |cp| cp.destroy }
      cart.should_not be_placeable
    end

    it 'should not be placeable if service_method is missing' do
      cart.service_method = ''
      cart.should_not be_placeable
    end

    it 'should not be placeable if the client is missing' do
      cart.client = nil
      cart.should_not be_placeable
    end
  end

  describe '#clear_store' do
    let!(:store){ create :store }
    let!(:user){ create :user, :operator }
    let!(:cart){ create :cart, user: user, store: store }

    it "should reset value to nil or zero " do
      cart.store.should == store
      cart.clear_store!
      cart.reload
      cart.store.should be_nil
      cart.user.should == user
    end

  end

  describe '#delivery?' do
    it "should return true if the service_method is delivery" do
      build(:cart, service_method: 'delivery').should be_delivery
    end
  end

  describe '#pickup?' do
    it "should return true if the service_method is pickup" do
      build(:cart, service_method: 'pickup').should be_pickup
    end
  end

  describe '#dinein?' do
    it "should return true if the service_method is dinein" do
      build(:cart, service_method: 'dinein').should be_dinein
    end
  end


  describe '#communication_fail!' do
    it 'should set the cart to critical if communication has failted' do
      cart = create(:cart)
      cart.should_not be_in('criticos')
      cart.communication_fail!
      cart.should be_in('criticos')
    end
  end


  describe '#clear_prices' do
    let!(:user){ create :user, :operator }
    let!(:cart){ create :cart, user: user, net_amount: 100, tax_amount: 45, tax1_amount: 20, tax2_amount: 15, payment_amount: 145 }
    let!(:cart_product){ create :cart_product , priced_at: 1000, cart: cart }

    it "should reset value to nil or zero " do
      cart.payment_amount.should == 145
      cart.clear_prices!
      cart.reload
      cart.net_amount.should be_nil
      cart.tax_amount.should be_nil
      cart.tax1_amount.should be_nil
      cart.tax2_amount.should be_nil
      cart.payment_amount.should be_nil
      cart.cart_products.first.priced_at.should be_nil
      cart.user.should == user
    end

  end

end
