#encoding: utf-8
class Admin::SettingsController < ApplicationController
  before_filter {|c| c.accessible_by([:admin], root_path)}
  def index
    @settings = Hashit.new(build_settings)
  end


  def create
    params[:settings].each_pair do | k, v|
      Kapiqua["#{k}"]= v
    end
    flash["success"]='Configuración actualizada'
    redirect_to admin_settings_path
  end

  private 
    def build_settings
      settings = {}
      settings['node_url'] = Kapiqua.node_url || Kapiqua.defaults[:node_url]
      settings['price_store_ip'] = Kapiqua.price_store_ip || Kapiqua.defaults[:price_store_ip]
      settings['price_store_id'] = Kapiqua.price_store_id || Kapiqua.defaults[:price_store_id]
      settings['pulse_port'] = Kapiqua.pulse_port || Kapiqua.defaults[:pulse_port]
      settings
    end
end
