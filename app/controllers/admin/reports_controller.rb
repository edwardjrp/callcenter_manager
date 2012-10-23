#encoding:  utf-8
class Admin::ReportsController < ApplicationController
    before_filter {|c| c.accessible_by([:admin], root_path)}

    def detailed
      @reports = Report.detailed.order('created_at DESC').page(params[:page])
      @search = Cart.finalized.search(params[:q])
      @carts = @search.result(:distinct => true).limit(5)
    end

    def generate_detailed 
      @search = Cart.finalized.search(params[:q])
      @report = Report.create(name: 'Detallado')
      begin
        @report.process_detailed(@search.result(:distinct => true))
        flash['success'] = "Reporte generado"
      rescue => error
        Rails.logger.info error
        flash['error'] = "Un error impidio la generación del reporte"
      end
      redirect_to admin_reports_detailed_path
    end

    def sumary
      @reports = Report.sumary.order('created_at DESC').page(params[:page])
      @search = Cart.finalized.search(params[:q])
      @carts = @search.result(:distinct => true).limit(5)
      # username = 'cdruser'
      # password = 'cdrus3rd1s8x10bctb3st'
      # nonce  = SecureRandom.hex(10)
      # token = Digest::MD5.hexdigest("#{username}:#{nonce}:#{Digest::MD5.hexdigest(password)}")
      # start_date = (Date.today - 2).to_s(:db)
      # end_date = Date.today.to_s(:db)
      # url = URI.parse("http://192.168.85.80:8080/totalincoming.json?fecha1=#{start_date}&fecha2=#{end_date}&token=#{token}&nonce=#{nonce}")
      # request = Net::HTTP.get(url)
      # @result = request
    end

    def generate_sumary
      @search = Cart.finalized.search(params[:q])
      @report = Report.create(name: 'Consolidado')
      # begin
        @report.process_sumary(@search.result(:distinct => true))
        flash['success'] = "Reporte generado"
      # rescue => error
      #   Rails.logger.info error
      #   flash['error'] = "Un error impidio la generación del reporte"
      # end
      redirect_to admin_report_sumary_path
    end
end
