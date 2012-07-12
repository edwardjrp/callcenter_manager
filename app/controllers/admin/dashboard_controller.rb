
class Admin::DashboardController < ApplicationController
  before_filter {|c| c.accesible_by([:admin], root_path)}
  def index
  end
end
