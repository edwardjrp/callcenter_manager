# == Schema Information
#
# Table name: carts
#
#  id                        :integer          not null, primary key
#  user_id                   :integer
#  client_id                 :integer
#  communication_failed      :boolean          default(FALSE)
#  status_text               :string(255)
#  store_id                  :integer
#  store_order_id            :string(255)
#  service_method            :string(255)
#  business_date             :datetime
#  advance_order_time        :datetime
#  net_amount                :decimal(, )
#  tax_amount                :decimal(, )
#  tax1_amount               :decimal(, )
#  tax2_amount               :decimal(, )
#  payment_amount            :decimal(, )
#  message                   :string(255)
#  order_text                :string(255)
#  order_progress            :string(255)
#  can_place_order           :boolean
#  delivery_instructions     :text
#  payment_type              :string(255)
#  credit_cart_approval_name :string(255)
#  fiscal_number             :string(255)
#  fiscal_type               :string(255)
#  company_name              :string(255)
#  discount                  :decimal(, )
#  discount_auth_id          :integer
#  completed                 :boolean          default(FALSE)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  message_mask              :integer
#  reason_id                 :integer
#

require 'spec_helper'

describe Cart do
  context 'Validation' do
    it { should validate_presence_of :user_id }
    it { should belong_to :user }
    it { should belong_to :client }
    it { should belong_to :store }
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
      mailboxes.should_not include('nuevos')
      mailboxes.should include('eliminados')
    end

    it "should mark as criticos" do
      cart.critical!
      mailboxes.should include('nuevos')
      mailboxes.should include('criticos')
    end

  end

  # describe '#clear_all' do
  #   let!(:client){ create :client }
  #   let!(:store){ create :store }
  #   let!(:user){ create :user, :operator }
  #   let!(:cart){ create :cart, client: client, payment_amount: 100.00, service_method: 'PickUp', store: store, user: user}

  #   it "should reset value to nil or zero " do
  #     cart.client.should == client
  #     cart.payment_amount.should == 100.00
  #     cart.service_method.should == 'PickUp'
  #     cart.store.should == store
  #     cart.clear_all
  #     cart.reload
  #     art.client.should be_nil
  #     cart.payment_amount.should == 0
  #     cart.service_method.should == be_blank
  #     cart.store.should == be_nil
  #     cart.user.should == user
  #   end
  # end

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
