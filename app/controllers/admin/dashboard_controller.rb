
class Admin::DashboardController < ApplicationController
  before_filter {|c| c.accessible_by([:admin], root_path)}
  def index
  end
end
