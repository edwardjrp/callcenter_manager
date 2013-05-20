# encoding:utf-8
require 'spec_helper'

describe Reports::Generator do
  let!(:start_time)   { Time.parse('2012-01-01 00:00:00 UTC') }
  let!(:reports_time) { Time.parse('2012-02-01 00:00:00 UTC') }
  let!(:end_time)     { Time.parse('2012-03-01 00:00:00 UTC') }

  describe '.name' do
    let!(:product) { build :product, productname: '8&quot; Tradicional Italiana'}

    it 'should return the unscaped productname' do
      Reports::Generator.normalize(product.productname).should == '8" Tradicional Italiana'
    end
  end


  shared_examples_for 'report contants' do |options|
    it "should return the #{options[:report_type]} title" do
      constant_title.should == options[:title]
    end

    it "should return the #{options[:report_type]} headers" do
      constant_columns.should =~ report_columns
    end

    it "should return true for the #{options[:report_type]} single_table type" do
      constant_single_table.should == true
    end
  end

  describe '::SUMARY_REPORT' do
    let!(:report_columns) {
      [
        'Ventas',
        'Otros Indicadores',
        'Product mix'
      ]
    }
    let!(:constant_title)        { Reports::Generator::SUMARY_REPORT[:title]        }
    let!(:constant_columns)      { Reports::Generator::SUMARY_REPORT[:columns]      }
    let!(:constant_single_table) { Reports::Generator::SUMARY_REPORT[:single_table] }

    it_behaves_like 'report contants', { report_type: 'Discount report', title: 'Reporte Consolidado', single_table: true }
  end



  describe '::DISCOUNTS_REPORT' do
    let!(:report_columns) {
      [
        'Agente',
        'Nombre del Agente',
        'Autorizado por',
        'Nombre Aut.',
        'Fecha y hora de orden',
        'Tienda',
        'Orden',
        'Info. Cliente',
        'Total Sin descuento',
        'Total Descontado',
        'Total c/ Desc.'
      ]
    }
    let!(:constant_title)        { Reports::Generator::DISCOUNTS_REPORT[:title]        }
    let!(:constant_columns)      { Reports::Generator::DISCOUNTS_REPORT[:columns]      }
    let!(:constant_single_table) { Reports::Generator::DISCOUNTS_REPORT[:single_table] }

    it_behaves_like 'report contants', { report_type: 'Discount report', title: 'Reporte de descuentos', single_table: true }
  end

  describe '::COUPONS_REPORT' do
    let!(:report_columns) {
      [
        'Código del Cupón',
        'Descripción',
        'Cantidad',
        '% del Total de ordenes',
        '% del Total de los Cupones'
      ]
    }
    let!(:constant_title)        { Reports::Generator::COUPONS_REPORT[:title]        }
    let!(:constant_columns)      { Reports::Generator::COUPONS_REPORT[:columns]      }
    let!(:constant_single_table) { Reports::Generator::COUPONS_REPORT[:single_table] }

    it_behaves_like 'report contants', { report_type: 'Coupons report', title: 'Reporte de cupones', single_table: true }
  end

  describe '::PER_HOUR_REPORT' do
    let!(:report_columns) {
      [
        'Periodo del día',
        'Ordenes',
        'Llamandas',
        'Cantidad de agentes conectado',
        'Ventas netas',
        'Tiempo promedio de toma de orden',
        'Ordenes Canceladas',
        'Delivery',
        'Carry Out',
        'Dine In'
      ]
    }
    let!(:constant_title)        { Reports::Generator::PER_HOUR_REPORT[:title]        }
    let!(:constant_columns)      { Reports::Generator::PER_HOUR_REPORT[:columns]      }
    let!(:constant_single_table) { Reports::Generator::PER_HOUR_REPORT[:single_table] }

    it_behaves_like 'report contants', { report_type: 'Per hour report', title: 'Reporte por hora', single_table: true }
  end

  describe '::DETAILED_REPORT' do
    let!(:report_columns) {
      [
        'No. Orden',
        'Tienda',
        'Nuevo cliente',
        'Cliente',
        'Fecha',
        'Modo de servicio',
        'Agente',
        'Tiempo de toma',
        'Monto de la order',
        'Metodo de pago',
        'Tipo de factura',
        'Estado en pulse',
        'Estado en CC',
        'Ítemes']
    }
    let!(:constant_title)        { Reports::Generator::DETAILED_REPORT[:title]        }
    let!(:constant_columns)      { Reports::Generator::DETAILED_REPORT[:columns]      }
    let!(:constant_single_table) { Reports::Generator::DETAILED_REPORT[:single_table] }

    it_behaves_like 'report contants', { report_type: 'Detailed report', title: 'Reporte detallado', single_table: true }
  end


  describe '::PRODUCT_MIX_REPORT' do
    let!(:report_columns) {
      [
        'Categoría',
        'Ítem de Menú',
        'Tamaño',
        'Sabor/Masa',
        'Ventas Netas',
        'Cantidad',
        'Product Mix',
        'Sales Mix',
        'Ordenes',
        'Percentage en Ordenes'
      ]
    }
    let!(:constant_title)        { Reports::Generator::PRODUCT_MIX_REPORT[:title]        }
    let!(:constant_columns)      { Reports::Generator::PRODUCT_MIX_REPORT[:columns]      }
    let!(:constant_single_table) { Reports::Generator::PRODUCT_MIX_REPORT[:single_table] }

    it_behaves_like 'report contants', { report_type: 'Product mix report', title: 'Reporte product mix', single_table: true }
  end

  describe 'Sumary report' do
    let(:dis_user) { create :user, :admin }
    let!(:cart1)   { create :cart, completed: true, started_on: reports_time , complete_on: reports_time + 20.seconds, discount_auth_id: dis_user.id, discount: 100, payment_amount: 300, net_amount: 250 }
    let!(:cart2)   { create :cart, completed: true, started_on: reports_time , complete_on: reports_time + 20.seconds, discount_auth_id: dis_user.id, discount: 80, payment_amount: 300, net_amount: 250  }

    before do
      create_list :cart_product, 2, cart: cart1, created_at: reports_time
      create_list :cart_product, 3, cart: cart2, created_at: reports_time
      Net::HTTP.stub(:get).and_return({ "resultcode" => 0, "result"=>{ "totalincoming" => 16573 } }.to_json)
    end

    let!(:sumary_report) do
      Reports::Generator.new Cart.scoped, :sumary_report, start_time, end_time do | product, product_count |
        [ product, product_count ]
      end
    end

    shared_examples_for 'Sumary report' do
      it 'should generate a pdf with the title' do
        should match(Reports::Generator::SUMARY_REPORT[:title])
      end

      it 'should have the headers' do
        should match(headers[0])
        should match(headers[1])
        should match(headers[2])
      end
    end

    describe '#render_pdf' do
      let!(:pdf)     { sumary_report.render_pdf }
      let!(:headers) { Reports::Generator::SUMARY_REPORT[:columns] }

      subject { PDF::Reader.new(StringIO.new(pdf)).page(1).text }

      it_behaves_like 'Sumary report'
    end

    describe '#render_csv' do
      let!(:csv)     { sumary_report.render_csv }
      let!(:headers) { Reports::Generator::SUMARY_REPORT[:columns] }

      subject { csv }

      it_behaves_like 'Sumary report'
    end
  end

  describe 'Discounts report' do
    let(:dis_user) { create :user, :admin }
    let!(:cart1)   { create :cart, completed: true, complete_on: reports_time, discount_auth_id: dis_user.id, discount: 100, payment_amount: 300 }
    let!(:cart2)   { create :cart, completed: true, complete_on: reports_time, discount_auth_id: dis_user.id, discount: 80, payment_amount: 300 }

    let!(:discounts_report) do
      Reports::Generator.new Cart.complete_in_date_range(start_time, end_time).discounted, :discounts_report, start_time, end_time do |cart|
        [
          cart.agent_info,
          cart.agent_info_name,
          cart.discount_authorizer,
          cart.discount_authorizer_name,
          cart.completion_info,
          cart.store_info_id,
          cart.complete_id,
          cart.client_info,
          Reports::Generator.monetize(cart.payment_amount),
          Reports::Generator.monetize(cart.discount),
          Reports::Generator.monetize((cart.payment_amount.to_d - cart.discount.to_d))
        ]
      end
    end

    shared_examples_for 'Discounts report' do
      it 'should generate a pdf with the title' do
        should match(Reports::Generator::DISCOUNTS_REPORT[:title])
      end

      it 'should have the headers' do
        should match(headers)
      end

      it 'should have the authorizer admin name' do
        should match(dis_user.first_name)
      end

      it 'should have the authorizer admin name' do
        should match('220')
        should match('200')
      end
    end

    describe '#render_pdf' do
      let!(:pdf)     { discounts_report.render_pdf }
      let!(:headers) { Reports::Generator::DISCOUNTS_REPORT[:columns].join }

      subject { PDF::Reader.new(StringIO.new(pdf)).page(1).text }

      it_behaves_like 'Discounts report'
    end

    describe '#render_csv' do
      let!(:csv)     { discounts_report.render_csv }
      let!(:headers) { Reports::Generator::DISCOUNTS_REPORT[:columns].join(',') }

      subject { csv }

      it_behaves_like 'Discounts report'
    end
  end

  describe 'Coupons report' do
    let!(:cart1) { create :cart, completed: true, complete_on: reports_time, coupons: create_list(:coupon, 10) }
    let!(:cart2) { create :cart, completed: true, complete_on: reports_time, coupons: create_list(:coupon, 10) }

    let!(:coupons_report) do
      Reports::Generator.new Cart.complete_in_date_range(start_time, end_time).joins(:coupons).group('coupons.code').count, :coupons_report, start_time, end_time do |coupon_code, coupon_count|
        [
          coupon_code,
          Coupon.where(code: coupon_code).first.description_info,
          coupon_count,
          Reports::Generator.percentize(coupon_count.to_d / Cart.completed.count.to_d) ,
          Reports::Generator.percentize(coupon_count.to_d / Cart.completed.joins(:coupons).count.to_d)
        ]
      end
    end

    shared_examples_for 'Coupons report' do
      it 'should generate a pdf with the title' do
        should match(Reports::Generator::COUPONS_REPORT[:title])
      end

      it 'should have the headers' do
        should match(headers)
      end

      it 'should have the coupons desccription' do
        should match(Cart.completed.first.coupons.first.description_info)
      end
    end

    describe '#render_pdf' do
      let!(:pdf)     { coupons_report.render_pdf }
      let!(:headers) { Reports::Generator::COUPONS_REPORT[:columns].join }

      subject { PDF::Reader.new(StringIO.new(pdf)).page(1).text }

      it_behaves_like 'Coupons report'
    end

    describe '#render_pdf' do
      let!(:csv)     { coupons_report.render_csv }
      let!(:headers) { Reports::Generator::COUPONS_REPORT[:columns].join(',') }

      subject { csv }

      it_behaves_like 'Coupons report'
    end

  end

  describe 'Per hour report' do
    let!(:cart1) { create :cart, completed: true, started_on: reports_time , complete_on: reports_time + 20.seconds }
    let!(:cart2) { create :cart, completed: true, started_on: (reports_time + 1.hour), complete_on: (reports_time + 1.hour) + 20.seconds  }
    let!(:calls_by_hour_result) do
      {
        "2013-03-06"=>{
          "0"=>"1",
          "1"=>"2",
          "7"=>"2",
          "10"=>"9",
          "11"=>"34",
          "12"=>"42",
          "13"=>"33",
          "14"=>"26",
          "15"=>"22",
          "16"=>"23",
          "17"=>"41",
          "18"=>"46",
          "19"=>"72",
          "20"=>"58",
          "21"=>"49",
          "22"=>"23",
          "23"=>"3"
        },
        "2013-03-07"=>{
          "10"=>"23",
          "11"=>"35",
          "12"=>"87",
          "13"=>"72",
          "14"=>"11"
        }
      }
    end

    let!(:agents_by_hour_result_hash) do
      {
        "2013-03-06"=>{
          "0"=>"1.0",
          "1"=>"1.0",
          "2"=>"1.0",
          "3"=>"1.0",
          "4"=>"1.0",
          "5"=>"1.0",
          "6"=>"1.0",
          "7"=>"1.0",
          "8"=>"1.0",
          "10"=>"2.0",
          "11"=>"3.75",
          "12"=>"4.75",
          "13"=>"5.0",
          "14"=>"4.75",
          "15"=>"5.0",
          "16"=>"2.75",
          "17"=>"6.0",
          "18"=>"8.75",
          "19"=>"9.5",
          "20"=>"10.0",
          "21"=>"10.0",
          "22"=>"3.5",
          "23"=>"1.0"
        },
        "2013-03-07"=>{
          "10"=>"4.3333",
          "11"=>"6.5",
          "12"=>"8.75",
          "13"=>"9.0",
          "14"=>"9.0"
        }
      }
    end

    before do
      Asterisk::Connector.any_instance.should_receive(:calls_by_hour).and_return(calls_by_hour_result)
      Asterisk::Connector.any_instance.should_receive(:agents_by_hour).and_return(agents_by_hour_result_hash)
    end

    let!(:per_hour_report) do
      Reports::Generator.new Cart.scoped, :per_hour_report, start_time, end_time do |datetime, telephony_hash|
        [
          "#{datetime.to_date} - #{datetime.strftime('%H')}",
          Cart.complete_in_date_range(start_time, end_time).where("date_part('hour', complete_on) = ?", datetime.strftime('%H')).count,
          telephony_hash[:call_by_hour][datetime.to_date.to_s(:db)] && telephony_hash[:call_by_hour][datetime.to_date.to_s(:db)][datetime.strftime('%H')] ? telephony_hash[:call_by_hour][datetime.to_date.to_s(:db)][datetime.strftime('%H')] : 0,
          telephony_hash[:agents_by_hour][datetime.to_date.to_s(:db)] && telephony_hash[:agents_by_hour][datetime.to_date.to_s(:db)][datetime.strftime('%H')] ? telephony_hash[:agents_by_hour][datetime.to_date.to_s(:db)][datetime.strftime('%H')] : 0,
          Reports::Generator.monetize(Cart.complete_in_date_range(start_time, end_time).where("date_part('hour', complete_on) = ?", datetime.strftime('%H')).sum('payment_amount')),
          Cart.average_take_time(start_time - 1.day, Time.now, start_time, end_time),
          Cart.abandoned_in_date_range(start_time, end_time).where("date_part('hour', updated_at) = ?", datetime.strftime('%H')).abandoned.count,
          Cart.complete_in_date_range(start_time, end_time).where("date_part('hour', complete_on) = ?", datetime.strftime('%H')).delivery.count,
          Cart.complete_in_date_range(start_time, end_time).where("date_part('hour', complete_on) = ?", datetime.strftime('%H')).pickup.count,
          Cart.complete_in_date_range(start_time, end_time).where("date_part('hour', complete_on) = ?", datetime.strftime('%H')).dinein.count
        ]
      end
    end

    shared_examples_for 'per hour report' do
      it 'should generate a pdf with the title' do
        should match(Reports::Generator::PER_HOUR_REPORT[:title])
      end

      it 'should have the headers' do
        should match(headers)
      end
    end

    describe '#render_pdf' do
      let!(:pdf)     { per_hour_report.render_pdf }
      let!(:headers) { Reports::Generator::PER_HOUR_REPORT[:columns].join }

      subject { PDF::Reader.new(StringIO.new(pdf)).page(1).text }

      it_behaves_like 'per hour report'
    end

    describe '#render_csv' do
      let!(:csv)     { per_hour_report.render_csv }
      let!(:headers) { Reports::Generator::PER_HOUR_REPORT[:columns].join(",") }

      subject { csv }

      it_behaves_like 'per hour report'
    end
  end

  describe 'Product mix report' do
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

    let!(:association)   { CartProduct.products_mix(start_time, end_time) }

    let!(:product_mix_report) do
      Reports::Generator.new association, :product_mix_report, start_time, end_time,  :landscape do |product, cart_products|
        [
          '',
          product.name,
          product.sizecode,
          product.flavorcode,
          Reports::Generator.monetize(cart_products.sum(&:priced_at)),
          cart_products.sum(&:quantity),
          Reports::Generator.percentize(cart_products.sum(&:priced_at).to_d / Cart.total_sells_in(start_time, end_time)),
          Reports::Generator.percentize(cart_products.sum(&:quantity).to_d / CartProduct.total_items_sold(start_time, end_time)),
          product.carts.complete_in_date_range(start_time, end_time).count,
          Reports::Generator.percentize(product.carts.complete_in_date_range(start_time, end_time).count.to_d / Cart.completed.date_range(start_time, end_time).count.to_d)
        ]
      end
    end

    shared_examples_for 'product mix report' do
      it 'should generate a pdf with the timestamp' do
        should match(start_time.strftime('%d %B %Y - %I:%M:%S %p'))
        should match(end_time.strftime('%d %B %Y - %I:%M:%S %p'))
      end

      it 'should generate a pdf with the title' do
        should match(Reports::Generator::PRODUCT_MIX_REPORT[:title])
      end

      it 'should have the headers' do
        should match(headers)
      end

      it 'should have sell Percentage' do
        sells = Reports::Generator.percentize(CartProduct.products_mix(start_time, end_time).values.first.last.last.sum(&:priced_at).to_d / Cart.total_sells_in(start_time, end_time))
        should match(sells)
      end
    end

    describe '#render_pdf' do
      let!(:pdf)     { product_mix_report.render_pdf }
      let!(:headers) { Reports::Generator::PRODUCT_MIX_REPORT[:columns].join }

      subject { PDF::Reader.new(StringIO.new(pdf)).page(1).text }

      it_behaves_like 'product mix report'
    end

    describe '#render_csv' do
      let!(:csv) { product_mix_report.render_csv }
      let!(:headers) { Reports::Generator::PRODUCT_MIX_REPORT[:columns].join(",") }

      subject { csv }

      it_behaves_like 'product mix report'
    end
  end

  describe 'Detailed report' do
    let(:cart1) { create :cart, completed: true, created_at: reports_time }
    let(:cart2) { create :cart, completed: true, created_at: reports_time }
    let(:carts) { [cart1, cart2] }


    before do
      Pulse::OrderStatus.any_instance.stub(:get).and_return('Makeline')
      create_list :cart_product, 2, cart: cart1, created_at: reports_time
      create_list :cart_product, 3, cart: cart2, created_at: reports_time
    end

    let!(:detailed_report) do
      Reports::Generator.new carts, :detailed_report, start_time, end_time,  :landscape do |cart|
        [
          cart.id,
          cart.store_info_id.to_s,
          cart.new_client?,
          cart.client_info,
          cart.completion_info,
          cart.service_method,
          cart.agent_info,
          cart.take_time_info,
          Reports::Generator.monetize(cart.payment_amount),
          cart.payment_type,
          cart.fiscal_type,
          cart.order_progress,
          cart.state,
          cart.products.map(&:name).to_sentence
        ]
      end
    end

    shared_examples_for 'Detailed report' do
      it 'should generate a pdf with the timestamp' do
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

      it 'should have cart payment info' do
        should match(cart1.payment_amount.round(2).to_s)
      end

      it 'should have cart products' do
        should match(cart1.products.first.name)
      end

      it 'should have cart pulse state' do
        should match('Makeline')
      end

      it 'should have the headers' do
        should match(headers)
      end
    end

    describe '#render_pdf' do
      let!(:pdf) { detailed_report.render_pdf }
      let!(:headers) { Reports::Generator::DETAILED_REPORT[:columns].join }

      subject { PDF::Reader.new(StringIO.new(pdf)).page(1).text }

      it_behaves_like 'Detailed report'
    end

    describe 'render_csv' do
      let!(:csv) { detailed_report.render_csv }
      let!(:headers) { Reports::Generator::DETAILED_REPORT[:columns].join(",") }

      subject { csv }

      it_behaves_like 'Detailed report'
    end
  end
end