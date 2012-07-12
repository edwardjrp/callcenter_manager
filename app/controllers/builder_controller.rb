
class BuilderController < ApplicationController
  before_filter {|c| c.accessible_by([:operator, :supervisor], admin_root_path)}
  def index
  end
end
