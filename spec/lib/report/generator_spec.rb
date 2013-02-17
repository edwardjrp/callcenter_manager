# encoding:utf-8
require 'spec_helper'

describe Reports::Generator do
  let!(:start_time)   { Time.parse('2012-01-01 00:00:00 UTC') }
  let!(:reports_time) { Time.parse('2012-02-01 00:00:00 UTC') }
  let!(:end_time)     { Time.parse('2012-03-01 00:00:00 UTC') }


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

  describe 'Discounts report' do
    let(:dis_user) { create :user, :admin }
    let!(:cart1)   { create :cart, completed: true, complete_on: reports_time, discount_auth_id: dis_user.id, discount: 100, payment_amount: 300 }
    let!(:cart2)   { create :cart, completed: true, complete_on: reports_time, discount_auth_id: dis_user.id, discount: 80, payment_amount: 300 }

    let!(:discounts_report) do
      Reports::Generator.new Cart.discounted, :discounts_report, start_time, end_time do |cart|
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
      Reports::Generator.new Cart.completed.joins(:coupons).group('coupons.code').count, :coupons_report, start_time, end_time do |coupon_code, coupon_count|
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

    let!(:per_hour_report) do
      Reports::Generator.new Cart.scoped, :per_hour_report, start_time, end_time do |datetime|
        [
          "#{datetime.to_date} - #{datetime.strftime('%H')}",
          Cart.complete_in_date_range(start_time, end_time).where("date_part('hour', complete_on) = ?", datetime.strftime('%H')).count,
          Reports::Generator.monetize(Cart.complete_in_date_range(start_time, end_time).where("date_part('hour', complete_on) = ?", datetime.strftime('%H')).sum('payment_amount')),
          Cart.average_take_time(start_time, end_time, datetime.hour),
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
    let!(:carts)         { create_list :cart, 10, completed: true, created_at: reports_time }
    let!(:cart_products) { create_list :cart_product, 20, created_at: reports_time, cart: carts.sample }
    let!(:association)   { CartProduct.products_mix(start_time, end_time) }

    let!(:product_mix_report) do
      Reports::Generator.new association, :product_mix_report, start_time, end_time,  :landscape do |product, cart_products|
        [
          '',
          product[:product].name,
          product[:product].sizecode,
          product[:product].flavorcode,
          Reports::Generator.monetize(product[:cart_products][:total_sales]),
          product[:cart_products][:total_count],
          Reports::Generator.percentize(product[:cart_products][:total_sales].to_d / Cart.total_sells_in(start_time, end_time)),
          Reports::Generator.percentize(product[:cart_products][:total_count].to_d / CartProduct.total_items_sold(start_time, end_time)),
          product[:total_carts],
          Reports::Generator.percentize(product[:total_carts].to_d / Cart.completed.date_range(start_time, end_time).count.to_d)
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
        sells = Reports::Generator.percentize(CartProduct.products_mix(start_time, end_time).first.last.first[:cart_products][:total_sales] / Cart.total_sells_in(start_time, end_time))
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