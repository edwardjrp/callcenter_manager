# == Schema Information
#
# Table name: reports
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  csv_file   :string(255)
#  pdf_file   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Report do
  describe 'Validation' do
    it{ should validate_presence_of :name }
    it{ should validate_uniqueness_of :name }
    it{ should validate_presence_of :csv_file }
    it{ should validate_presence_of :pdf_file }
  end

  describe '.available_reports' do
    it 'should return a symbol array of report types' do
      Report.available_reports.should =~ [:detailed_report, :product_mix_report, :per_hour_report, :coupons_report, :discounts_report, :sumary_report]
    end
  end

  describe '.report_types' do
    it 'should return a string array of report types' do
      Report.report_types.should =~ %W( Detallado Consolidado Cupones Descuentos ProductsMix PorHora )
    end
  end

  describe 'generate' do
    let!(:start_time)   { Time.parse('2012-01-01 00:00:00 UTC') }
    let!(:reports_time) { Time.parse('2012-02-01 00:00:00 UTC') }
    let!(:end_time)     { Time.parse('2012-03-01 00:00:00 UTC') }

    describe 'Detailed report' do
      let!(:cart1) { create :cart, completed: true, complete_on: reports_time }
      let!(:cart2) { create :cart, completed: true, complete_on: reports_time }
      let!(:cart3) { create :cart, completed: true, reason_id: 1,  updated_at: reports_time }

      before do
        Pulse::OrderStatus.any_instance.stub(:get).and_return('Makeline')
        create_list :cart_product, 2, cart: cart1, created_at: reports_time 
        create_list :cart_product, 3, cart: cart2, created_at: reports_time 
      end

      let!(:report) { Report.new(name: 'Detallado').generate(start_time,end_time) }

      subject { File.read(report.csv_file.path) }

      it 'should have the pdf and csv files' do
        report.should be_persisted
      end

      it 'should have the report data' do
        should match(start_time.strftime('%d %B %Y - %I:%M:%S %p'))
        should match(end_time.strftime('%d %B %Y - %I:%M:%S %p'))
      end

      it 'should generate a pdf with the title' do
        should match(Reports::Generator::DETAILED_REPORT[:title])
      end

      it 'should have cart store info' do
        should match(cart1.store_info_id.to_s)
      end

      it 'should have cart state' do
        should match('completed')
      end

      it 'should have cart new_client info' do
        should match(cart1.client_info)
      end

      it 'should abandoned cart info' do
        should match(cart3.id.to_s)
        should match(cart3.state)
      end

      it 'should have cart payment info' do
        should match(cart1.payment_amount.round(2).to_s)
      end

      it 'should have cart products' do
        should match(cart1.products.first.name)
      end

      it 'should have cart pulse state' do
        should match('Makeline')
      end
    end

    describe 'ProductsMix report' do
      let(:category1) { create :category }
      let(:category2) { create :category }

      let(:product1)  { create :product, category: category1 }
      let(:product2)  { create :product, category: category2 }
      let(:product3)  { create :product, category: category2 }
      let!(:products)  { [product1, product2, product3] }

      let!(:cart1) { create :cart, completed: true, complete_on: reports_time }
      let!(:cart2) { create :cart, completed: true, complete_on: reports_time }
      let!(:cart3) { create :cart, completed: true, complete_on: Time.zone.now }

      let!(:complete_cart_products1) { create_list :cart_product, 2, cart: cart1, product: products[0], created_at: reports_time  }
      let!(:complete_cart_products2) { create_list :cart_product, 3, cart: cart2, product: products[1], created_at: reports_time  }
      let!(:complete_cart_products3) { create_list :cart_product, 2, cart: cart3, product: products[2], created_at: Time.zone.now }

      let!(:report) { Report.new(name: 'ProductsMix').generate(start_time,end_time) }

      subject { File.read(report.csv_file.path) }

      it 'should have the pdf and csv files' do
        report.should be_persisted
      end

      it 'should have the report data' do
        should match(start_time.strftime('%d %B %Y - %I:%M:%S %p'))
        should match(end_time.strftime('%d %B %Y - %I:%M:%S %p'))
      end

      it 'should have sell Percentage' do
        sells = Reports::Generator.percentize(CartProduct.products_mix(start_time, end_time).values.first.last.last.sum(&:priced_at).to_d / Cart.total_sells_in(start_time, end_time))
        should match(sells)
      end
    end

    describe 'Coupons report' do
      let!(:cart1) { create :cart, completed: true, complete_on: reports_time, coupons: create_list(:coupon, 10) }
      let!(:cart2) { create :cart, completed: true, complete_on: reports_time, coupons: create_list(:coupon, 10) }

      let!(:report) { Report.new(name: 'Cupones').generate(start_time,end_time) }

      subject { File.read(report.csv_file.path) }

      it 'should have the pdf and csv files' do
        report.should be_persisted
      end

      it 'should have the report data' do
        should match(start_time.strftime('%d %B %Y - %I:%M:%S %p'))
        should match(end_time.strftime('%d %B %Y - %I:%M:%S %p'))
      end
    end

    describe 'discounts report' do
      let(:dis_user) { create :user, :admin }
      let!(:cart1)   { create :cart, completed: true, complete_on: reports_time, discount_auth_id: dis_user.id, discount: 100, payment_amount: 300 }
      let!(:cart2)   { create :cart, completed: true, complete_on: reports_time, discount_auth_id: dis_user.id, discount: 80, payment_amount: 300 }

      let!(:report) { Report.new(name: 'Descuentos').generate(start_time,end_time) }

      subject { File.read(report.csv_file.path) }

      it 'should have the pdf and csv files' do
        report.should be_persisted
      end

      it 'should have the report data' do
        should match(start_time.strftime('%d %B %Y - %I:%M:%S %p'))
        should match(end_time.strftime('%d %B %Y - %I:%M:%S %p'))
      end

      it 'should have the authorizer admin name' do
        should match(dis_user.first_name)
      end

      it 'should have the authorizer admin name' do
        should match('220')
        should match('200')
      end
    end

    describe 'sumary report' do
      let(:dis_user) { create :user, :admin }
      let!(:cart1)   { create :cart, completed: true, started_on: reports_time , complete_on: reports_time + 20.seconds, discount_auth_id: dis_user.id, discount: 100, payment_amount: 300 }
      let!(:cart2)   { create :cart, completed: true, started_on: reports_time , complete_on: reports_time + 20.seconds, discount_auth_id: dis_user.id, discount: 80, payment_amount: 300  }

      before do
        create_list :cart_product, 2, cart: cart1, created_at: reports_time 
        create_list :cart_product, 3, cart: cart2, created_at: reports_time 
        Net::HTTP.stub(:get).and_return({"resultcode"=>0, "result"=>{"totalincoming"=>16573}}.to_json)
      end

      let!(:report) { Report.new(name: 'Consolidado').generate(start_time,end_time) }

      subject { File.read(report.csv_file.path) }

      it 'should have the pdf and csv files' do
        report.should be_persisted
      end

      it 'should have the report data' do
        should match(start_time.strftime('%d %B %Y - %I:%M:%S %p'))
        should match(end_time.strftime('%d %B %Y - %I:%M:%S %p'))
      end
    end
  end
end
