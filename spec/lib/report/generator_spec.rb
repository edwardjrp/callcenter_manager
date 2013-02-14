# encoding:utf-8
require 'spec_helper'

describe Reports::Generator do
  before do
    Pulse::OrderStatus.any_instance.stub(:get).and_return('Makeline')
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

  describe 'Product mix report' do
    let!(:carts)         { create_list :cart, 10, completed: true }
    let!(:cart_products) { create_list :cart_product, 50, created_at: 1.hour.ago, cart: carts.sample }
    let!(:association)   { CartProduct.products_mix(2.hours.ago, Time.zone.now) }

    let!(:product_mix_report) do
      Reports::Generator.new association, :product_mix_report, 2.hour.ago, Time.zone.now,  :landscape do |product, cart_products|
        [
          '',
          product[:product].productname,
          product[:product].sizecode,
          product[:product].flavorcode,
          Reports::Generator.monetize(product[:cart_products][:total_sales]),
          product[:cart_products][:total_count],
          Reports::Generator.percentize(product[:cart_products][:total_sales].to_d / Cart.total_sells_in(2.hour.ago, Time.zone.now)), #.tap{|c| STDOUT.puts c.inspect },
          Reports::Generator.percentize(product[:cart_products][:total_count].to_d / CartProduct.total_items_sold(2.hour.ago, Time.zone.now)),
          product[:total_carts],
          Reports::Generator.percentize(product[:total_carts].to_d / Cart.completed.date_range(2.hour.ago, Time.zone.now).count.to_d)
        ]
      end
    end

    describe '#render_pdf' do
      let!(:pdf) { product_mix_report.render_pdf }

      subject { PDF::Reader.new(StringIO.new(pdf)).page(1).text }

      it 'should generate a pdf with the timestamp' do
        should match(Date.current.strftime('%d %B %Y'))
        should match(Date.current.prev_month.strftime('%d %B %Y'))
      end

      it 'should generate a pdf with the title' do
        STDOUT.puts subject
        # STDOUT.puts Cart.total_sells_in(2.hour.ago, Time.zone.now)
        # STDOUT.puts carts.map(&:payment_amount)
        should match(Reports::Generator::PRODUCT_MIX_REPORT[:title])
      end
    end
  end

  describe 'Detailed report' do
    let(:cart1) { create :cart, completed: true }
    let(:cart2) { create :cart, completed: true }
    let(:carts) { [cart1, cart2] }

    before do
      create_list :cart_product, 2, cart: cart1
      create_list :cart_product, 3, cart: cart2
    end

    let!(:detailed_report) do
      Reports::Generator.new carts, :detailed_report, Date.current.prev_month, Date.current,  :landscape do |cart|
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
        should match(Date.current.strftime('%d %B %Y'))
        should match(Date.current.prev_month.strftime('%d %B %Y'))
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
    end 

    describe '#render_pdf' do
      let!(:pdf) { detailed_report.render_pdf }

      subject { PDF::Reader.new(StringIO.new(pdf)).page(1).text }

      it_behaves_like 'Detailed report'
    end

    describe 'render_csv' do
      let!(:csv) { detailed_report.render_csv }

      subject { csv }

      it_behaves_like 'Detailed report'
    end
  end
end