# encoding: utf-8
# == Schema Information
#
# Table name: carts
#
#  id                          :integer          not null, primary key
#  user_id                     :integer
#  client_id                   :integer
#  communication_failed        :boolean          default(FALSE)
#  status_text                 :string(255)
#  store_id                    :integer
#  store_order_id              :string(255)
#  service_method              :string(255)
#  business_date               :datetime
#  advance_order_time          :datetime
#  net_amount                  :decimal(, )
#  tax_amount                  :decimal(, )
#  tax1_amount                 :decimal(, )
#  tax2_amount                 :decimal(, )
#  payment_amount              :decimal(, )
#  message                     :string(255)
#  order_text                  :string(255)
#  order_progress              :string(255)
#  can_place_order             :boolean
#  delivery_instructions       :text
#  payment_type                :string(255)
#  credit_card_approval_number :string(255)
#  fiscal_number               :string(255)
#  fiscal_type                 :string(255)
#  company_name                :string(255)
#  discount                    :decimal(, )
#  discount_auth_id            :integer
#  completed                   :boolean          default(FALSE)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  message_mask                :integer
#  reason_id                   :integer
#  complete_on                 :datetime
#  placed_at                   :datetime
#  exonerated                  :boolean
#  started_on                  :datetime
#  exoneration_authorizer      :integer
#  creditcard_number           :string(255)
#  fiscal_company_name         :string(255)
#  offline                     :boolean          default(FALSE)
#  communication_failed_on     :datetime
#

require 'csv'
class Cart < ActiveRecord::Base
  include Reports::Carts
  # attr_accessible :title, :body
  scope :recents, where('message_mask = 1 or message_mask = 9')
  scope :archived, where(message_mask: 2)
  scope :trashed, where(message_mask: 4)
  scope :untrashed, where('message_mask != 4')                                   
  scope :criticals, where('message_mask = 8 or message_mask = 9 or message_mask = 10 or message_mask = 12')
  scope :completed, where(:completed=>true).untrashed
  scope :incomplete, where(:completed=>false).untrashed
  scope :abandoned, where('reason_id IS NOT NULL').untrashed
  scope :available, where('reason_id IS NULL').untrashed
  scope :comm_failed, where(communication_failed: true).untrashed
  scope :finalized, where('completed = ? or reason_id IS NOT NULL', true).untrashed
  scope :latest, order('created_at DESC').untrashed
  scope :discounted, where('discount > ?', 0).untrashed
  belongs_to :user, :counter_cache => true
  belongs_to :client
  belongs_to :store
  belongs_to :reason
  has_many :cart_coupons, dependent: :destroy
  has_many :coupons, through: :cart_coupons
  has_many :cart_products, dependent: :destroy
  has_many :products, through: :cart_products
  has_many :user_carts, dependent: :destroy
  before_create :set_default_mailbox
  
  validates :user_id, presence: true
  
  
  # self.per_page = 20

  def copy_products(old_cart)
    return false if old_cart.cart_products.count.zero?
    transaction do 
      old_cart.cart_products.each do |cart_product|
        current_cart_product = cart_products.where(product_id: cart_product.product_id, bind_id: cart_product.bind_id, options: cart_product.options ).first_or_initialize
        unless current_cart_product.new_record?
          current_cart_product.quantity = current_cart_product.quantity + cart_product.quantity
        else
          current_cart_product.quantity = cart_product.quantity
        end
        current_cart_product.save
      end
    end
    old_cart
  end

  def discount_authorizer
    return nil if discount_auth_id.nil?
    return 'No encontrado' unless User.exists? discount_auth_id
    User.find(discount_auth_id).idnumber.gsub(/([0-9]{3})([0-9]{7})([0-9]{1})/,"\\1-\\2-\\3")
  end

  def discount_authorizer_name
    return nil if discount_auth_id.nil?
    return 'No encontrado' unless User.exists? discount_auth_id
    User.find(discount_auth_id).full_name
  end

  def exoneration_authorizer_info
    return nil if exoneration_authorizer.nil?
    return 'No encontrado' unless User.exists? exoneration_authorizer
    User.find(exoneration_authorizer).idnumber.gsub(/([0-9]{3})([0-9]{7})([0-9]{1})/,"\\1-\\2-\\3")
  end

  def offline_info
    return 'Si' if offline?
    'No'
  end

  def store_info
    return 'N/A' if store.nil?
    store.name
  end

  def store_info_id
    return 'N/A' if store.nil?
    store.storeid
  end

  def complete_id
    return id if store_order_id.blank?
    "#{id} id en Pulse #{store_order_id}"
  end

  def store_order_id_info
    return store_order_id if store_order_id.present?
    'N/A'
  end

  def new_client?
    return 'N/A' if client.nil?
    client.carts.count == 1 ? '*' : ''
  end

  def client_info
    return 'N/A' if client.nil?
    return "#{client.full_name} - #{client.last_phone.number.gsub(/([0-9]{3})([0-9]{3})([0-9]{4})/,'\\1-\\2-\\3')}" if client.phones.count.nonzero?
    client.full_name
  end

  def exonerated_info
    return 'Si' if exonerated == true
    'No'
  end

  def completion_info
    return 'N/A' if complete_on.nil?
    complete_on.strftime('%Y-%m-%d %H:%M:%S')
  end

  def starting_info
    return 'N/A' if started_on.nil?
    started_on.strftime('%Y-%m-%d %H:%M:%S')
  end

  def agent_info
    return 'N/A' if user.nil?
    user.idnumber.gsub(/([0-9]{3})([0-9]{7})([0-9]{1})/,'\\1-\\2-\\3')
  end

  def agent_info_name
    return 'N/A' if user.nil?
    user.full_name
  end

  def take_time_info
    return 'N/A' if complete_on.nil?
    return 'N/A' if started_on.nil?
    "#{take_time.to_i} segundos "
  end

  def self.filter_carts(filter)
    self.send(filter.to_sym)
  end


  def self.service_methods
    %w( delivery pickup dinein )
  end

  def self.before_hour(hour)
    where("date_part('hour',complete_on) < ?", hour)
  end

  def self.after_hour(hour)
    where("date_part('hour',complete_on) >= ?", hour)
  end

  def self.lunch
    before_hour(16)
  end

  def self.dinner
    after_hour(16)
  end

  def self.average_and_count_per_group( group_column = 'user_id', start_time = 1.hour.ago, order_column = 'carts_count')
    carts = self.scoped
    carts = carts.merge(self.completed)
    carts = carts.merge(self.select('AVG(carts.payment_amount) as carts_payment_avg'))
    carts = carts.merge(self.group("#{group_column}"))
    carts = carts.merge(self.where('complete_on > ?', start_time))
    carts = carts.merge(self.select("carts.#{group_column}, COUNT(carts.*) as carts_count"))
    carts = carts.merge(self.order("#{order_column} DESC"))
    group_column_name = group_column.gsub(/_id$/,'')
    group_column_model = group_column.gsub(/_id$/,'').classify.constantize
    carts.map do | user_carts |
      { "#{group_column_name}"=> group_column_model.find( user_carts["#{group_column}"] ), :carts_count => user_carts.carts_count , :payment_amount => user_carts.carts_payment_avg }
    end
  end

  def perform_discount(username, password, discount_amount)
    admin = User.find_by_username(username)
    if admin 
      if admin.admin? && admin.try(:authenticate, password)
        if self.payment_amount.present? && (self.payment_amount - discount_amount.to_d ) > 0
          self.discount_auth_id = admin.id
          self.discount = discount_amount.to_d
          self.save
        else
          self.errors.add(:base, 'El el monto a descontar no es valido')  
        end
      else
        self.errors.add(:base, 'El usuario provisto no tiene suficientes provilegios')
      end
    else
      self.errors.add(:base, 'No se encontro el usuario provisto para la autorización')
    end
    self.errors.empty?
  end

  def self.date_range(start_date, end_date)
    where('carts.created_at > ? and carts.created_at < ?', start_date, end_date)
  end

  def self.complete_in_date_range(start_date, end_date)
    where('carts.complete_on > ? and carts.complete_on < ?', start_date, end_date)
  end

  def placeable?
    errors.add :base, 'No ha seleccionado una tienda' if self.store.nil?
    errors.add :base, 'No ha seleccionado un modo de servicio' if self.service_method.blank?
    errors.add :base, 'No ha introducido productos a la orden' if self.cart_products.count.zero?
    if self.client.nil?
      errors.add :base, 'No ha seleccionado un cliente'
    else
      errors.add :base, 'El cliente no tiene numero telefonico asignado' if self.client.last_phone.nil?
      errors.add :base, 'El modo de servicio es delivery pero no hay una dirección asignada' if self.client.last_address.nil? and self.delivery?
    end
    errors.empty?
  end


  def exonerate(username, password)
    admin = User.find_by_username(username)
    if admin 
      if admin.admin? && admin.try(:authenticate, password)
        self.exoneration_authorizer = admin.id
        self.exonerated = true
        self.save         
      else
        self.errors.add(:base, 'El usuario provisto no tiene suficientes provilegios')
      end
    else
      self.errors.add(:base, 'No se encontro el usuario provisto para la autorización')
    end
    self.errors.empty?
  end

  def set_default_store!
    unless client.nil?
      address = client.last_address
      if address.present? && address.store.present?
        self.store = address.store
        self.save!
      end
    end
  end

  def reset_for_new_client!
    self.started_on = Time.now
    clear_store!
    clear_discount!
    clear_prices!
    clear_service_method!
  end

  def clear_client!
    self.client = nil
    self.save!
  end

  def clear_service_method!
    self.service_method = nil
    self.save!
  end

  def clear_store!
    self.store = nil
    self.save!
  end

  def clear_discount!
    self.discount = nil
    self.discount_auth_id = nil
    self.save!
  end

  # no test - perform in node
  def take_time
    if self.completed?
      (complete_on - started_on) if complete_on && started_on
    end
  end

  def clear_prices!
    self.net_amount = nil
    self.tax_amount = nil
    self.tax1_amount = nil
    self.tax2_amount = nil
    self.payment_amount = nil
    self.cart_products.each do | cart_product |
      cart_product.priced_at = nil
      cart_product.save
    end
    self.save!
  end
  
  def delivery?
    self.service_method.present? and (self.service_method == self.class.service_methods[0])
  end
  
  def pickup?
    self.service_method.present? and (self.service_method == self.class.service_methods[1])
  end
  
  def dinein?
    self.service_method.present? and (self.service_method == self.class.service_methods[2])
  end
  
  def self.valid_mailboxes
     #    1         2             4             8
     ['nuevos', 'archivados', 'eliminados', 'criticos']
  end

  def self.available_mailboxes
     #    1         2             4             8
     ['recents', 'archived', 'trashed', 'criticals']
  end

  def self.translate_mailbox(mailbox)
    self.available_mailboxes[self.valid_mailboxes.index(mailbox)]
  end
  
  def mailboxes=(sent_mailboxes)
    current_mailboxes = []
    return current_mailboxes if sent_mailboxes.blank?
    current_mailboxes.push(sent_mailboxes) if sent_mailboxes.is_a? String
    current_mailboxes = sent_mailboxes.compact
    self.message_mask = (current_mailboxes & self.class.valid_mailboxes).map { |r| 2**self.class.valid_mailboxes.index(r) }.sum
  end

  def mailboxes
    self.class.valid_mailboxes.reject do |r|
      ((message_mask || 0) & 2**self.class.valid_mailboxes.index(r)).zero?
    end
  end

  def self.find_mailbox(mailbox)
    case mailbox
      when 'nuevos'
        self.recents
      when 'archivados'
        self.archived
      when 'eliminados'
        self.trashed
      when 'criticos'
        self.criticals
    end
  end

  def communication_fail!
    self.communication_failed = true
    self.critical!
  end

  def set_default_mailbox
    self.mailboxes = ['nuevos']
  end
  
  def archive!
     self.mailboxes = ['archivados']
     self.save
  end

  def trash!
     self.mailboxes = ['eliminados']
     self.save
  end

  def critical!
    self.mailboxes = self.mailboxes.push('criticos')
    self.save
  end

  def in?(mailbox)
     self.mailboxes.include?(mailbox)
  end

  def update_pulse_order_status
    begin
      Timeout.timeout(15) do
        if self.store_order_id    
          self.order_progress = Pulse::OrderStatus.new(self.store, self.store_order_id).get
        else
          self.order_progress = 'N/A - Falta id de la orden'
        end
      end
    rescue Timeout::Error
      self.order_progress = 'N/A - No hay respuesta de pulse'
    end
    self.save!
  end
end
