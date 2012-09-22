require 'csv'
# == Schema Information
#
# Table name: carts
#
#  id                        :integer          not null, primary key
#  user_id                   :integer
#  client_id                 :integer
#  communication_failed      :boolean          default(FALSE)
#  status_text               :string(255)
#  store_id                  :integer
#  store_order_id            :string(255)
#  service_method            :string(255)
#  business_date             :datetime
#  advance_order_time        :datetime
#  net_amount                :decimal(, )
#  tax_amount                :decimal(, )
#  tax1_amount               :decimal(, )
#  tax2_amount               :decimal(, )
#  payment_amount            :decimal(, )
#  message                   :string(255)
#  order_text                :string(255)
#  order_progress            :string(255)
#  can_place_order           :boolean
#  delivery_instructions     :text
#  payment_type              :string(255)
#  credit_cart_approval_name :string(255)
#  fiscal_number             :string(255)
#  fiscal_type               :string(255)
#  company_name              :string(255)
#  discount                  :decimal(, )
#  discount_auth_id          :integer
#  completed                 :boolean          default(FALSE)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  message_mask              :integer
#

class Cart < ActiveRecord::Base
  # attr_accessible :title, :body
  scope :completed, where(:completed=>true)
  scope :incomplete, where(:completed=>false)
  scope :latest, order('created_at DESC')
  belongs_to :user
  belongs_to :client
  belongs_to :store
  has_many :cart_products
  has_many :products, :through=> :cart_products
  before_create :set_default_mailbox
  
  validates :user_id, presence: true
  
  scope :recents, where(message_mask: 1)
  scope :archived, where(message_mask: 2)
  scope :trashed, where(message_mask: 4)
  scope :criticals, where('message_mask = 8 or message_mask = 9 or message_mask = 10 or message_mask = 12')
  # self.per_page = 20


  def self.service_methods
    %w( delivery pickup carryout )
  end

  def reset_for_new_client!
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
    self.service_method == self.class.service_methods[0]
  end
  
  def pickup?
      self.service_method == self.class.service_methods[1]
  end
  
  def carry_out?
      self.service_method == self.class.service_methods[2]
  end
  
  def self.valid_mailboxes
     #    1         2             4             8
     ['nuevos', 'archivados', 'eliminados', 'criticos']
  end
  

  def self.detailed_report#(start_time, end_time)
    CSV.generate do |csv|
      csv << ['No. Orden', 'Tienda', 'Nuevo cliente', 'Cliente', 'Fecha', 'Modo de servicio', 'Agente', 'Tiempo de toma', 'Monto de la order', 'Pago efectivo', 'Typo de factura', 'Estado en pulse']
      all.each do |cart|
        csv << [
          cart.id,
          cart.store.storeid,
          (cart.client && cart.client.carts.count.nonzero?),
          "#{cart.client.first_name} #{cart.client.last_name} - #{cart.client.last_phone.number.gsub(/([0-9]{3})([0-9]{3})([0-9]{4})/,'\\1-\\2-\\3')}",
          cart.created_at.strftime('%Y-%m-%d %H:%M:%S'), # there has to be a completed_on field
          cart.service_method,
          cart.user.idnumber,
          'Provisto por asterisk',
          cart.payment_amount,
          cart.payment_type,
          cart.fiscal_type || 'FinalConsumer',
          cart.order_progress,
          cart.products.map(&:productname).to_sentence
           ]
      end
    end
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
