
class Admin::DashboardController < ApplicationController
  before_filter {|c| c.accessible_by([:admin], root_path)}
  def index
    # @hour = Time.how.hour
    @users_per_carts_by_counts = Cart.average_and_count_per_group
    @users_per_carts_by_avgs = Cart.average_and_count_per_group('user_id',2.weeks.ago,'carts_payment_avg', 5)

    @store_per_carts_by_counts = Cart.average_and_count_per_group('store_id')
    @store_per_carts_by_avgs = Cart.average_and_count_per_group('store_id',2.weeks.ago,'carts_payment_avg', 5)
    # Rails.cache.write("sales")
  end
end
