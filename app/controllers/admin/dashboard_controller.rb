
class Admin::DashboardController < ApplicationController
  before_filter {|c| c.accessible_by([:admin, :supervisor], root_path)}
  def index
    @users_per_carts_by_counts = Cart.average_and_count_per_group
    @users_per_carts_by_avgs = Cart.average_and_count_per_group('user_id',1.hour.ago,'carts_payment_avg', 5)

    @store_per_carts_by_counts = Cart.average_and_count_per_group('store_id')
    @store_per_carts_by_avgs = Cart.average_and_count_per_group('store_id', 1.hour.ago,'carts_payment_avg', 5)

    @users_per_carts_by_counts_day = Cart.average_and_count_per_group('user_id',Date.today.beginning_of_day,'carts_count', 5)
    @users_per_carts_by_avgs_day = Cart.average_and_count_per_group('user_id',Date.today.beginning_of_day,'carts_payment_avg', 5)

    @store_per_carts_by_counts_day = Cart.average_and_count_per_group('store_id', Date.today.beginning_of_day,'carts_count', 5)
    @store_per_carts_by_avgs_day = Cart.average_and_count_per_group('store_id', Date.today.beginning_of_day,'carts_payment_avg', 5)

    @total_sells_for_today = Cart.completed.complete_in_date_range(Date.today.beginning_of_day, Time.now).sum('payment_amount')
    @net_sells_for_today = Cart.completed.complete_in_date_range(Date.today.beginning_of_day, Time.now).sum('net_amount')
    @abandone_for_today = Cart.completed.complete_in_date_range(Date.today.beginning_of_day, Time.now).abandoned.count

    @service_methods = Cart.completed.complete_in_date_range(Date.today.beginning_of_day, Time.now).group(:service_method).count
    


    respond_to do |format|
      format.js
      format.html
    end
  end
end
