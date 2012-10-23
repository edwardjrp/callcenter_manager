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
#

require 'csv'
class Cart < ActiveRecord::Base
  include Reports::Carts
  # attr_accessible :title, :body
  scope :completed, where(:completed=>true)
  scope :incomplete, where(:completed=>false)
  scope :abandoned, where('reason_id IS NOT NULL')
  scope :available, where('reason_id IS NULL')
  scope :finalized, where('completed = ? or reason_id IS NOT NULL', true)
  scope :latest, order('created_at DESC')
  belongs_to :user, :counter_cache => true
  belongs_to :client
  belongs_to :store
  belongs_to :reason
  has_many :cart_coupons, dependent: :destroy
  has_many :coupons, through: :cart_coupons
  has_many :cart_products, dependent: :destroy
  has_many :products, through: :cart_products
  before_create :set_default_mailbox
  
  validates :user_id, presence: true
  
  scope :recents, where(message_mask: 1)
  scope :archived, where(message_mask: 2)
  scope :trashed, where(message_mask: 4)
  scope :criticals, where('message_mask = 8 or message_mask = 9 or message_mask = 10 or message_mask = 12')
  # self.per_page = 20


  def self.service_methods
    %w( delivery pickup dinein )
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
      complete_on - started_on if complete_on && started_on
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
  
end
