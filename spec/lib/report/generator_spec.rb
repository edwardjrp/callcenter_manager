# encoding:utf-8
require 'spec_helper'

describe Reports::Generator do
  shared_examples_for 'report contants' do |options|
    it "should return the #{options[:report_type]} title" do
      Reports::Generator::DETAILED_REPORT[:title].should == options[:title]
    end

    it "should return the #{options[:report_type]} headers" do
      Reports::Generator::DETAILED_REPORT[:columns].should =~ report_columns
    end

    it "should return true for the #{options[:report_type]} single_table type" do
      Reports::Generator::DETAILED_REPORT[:single_table].should == true
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
    it_behaves_like 'report contants', { report_type: 'Detailed report', title: 'Reporte detallado', single_table: true }
  end

  describe '#render' do
    let(:cart_products) { create_list :cart_product, 4 }
    let(:carts) { cart_products.map(&:cart) }
    let!(:pdf) {
      Reports::Generator.new(carts,:detailed_report, Date.current.prev_month, Date.current).render do |cart|
          [
            cart.id,
            cart.store_info,
            cart.new_client?,
            cart.client_info,
            cart.completion_info, # there has to be a completed_on field
            cart.service_method,
            cart.agent_info,
            cart.take_time_info,
            Reports::Generator.monetize(cart.payment_amount),
            cart.payment_type,
            cart.fiscal_type,
            cart.order_progress,
            cart.products.map(&:productname).to_sentence
          ]
        end
    }

    subject { PDF::Reader.new(StringIO.new(pdf)).page(1).text }

    context 'report type = detailed_report' do
      it 'should generate a pdf with the timestamp' do
        should match(Date.current.strftime('%d %B %Y'))
        should match(Date.current.prev_month.strftime('%d %B %Y'))
      end

      it 'should generate a pdf with the title' do
        should match(Reports::Generator::DETAILED_REPORT[:title])
      end
    end
  end
end