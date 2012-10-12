# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string(255)
#  first_name      :string(255)
#  last_name       :string(255)
#  auth_token      :string(255)
#  password_digest :string(255)
#  role_mask       :integer
#  last_action_at  :datetime
#  login_count     :integer          default(0)
#  carts_count     :integer          default(0)
#  idnumber        :string(255)
#  active          :boolean          default(TRUE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  has_secure_password
  validates :username, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :idnumber, presence: true, uniqueness: true, length: { :is => 11 }, allow_blank: true
  has_many :carts
  attr_accessible :first_name, :last_name, :idnumber, :username, :password, :password_confirmation, :roles, :active
  before_create :generate_auth_token
  before_destroy :ensure_has_no_carts
  before_destroy :there_is_one_admin
  scope :admins, where('role_mask = ? ', 1)
  
  def self.authenticate(username, password)
      user = find_by_username(username)
      user.try(:authenticate, password) if user.present? && user.active?
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
 

  def roles=(sent_roles)
    self.role_mask = (normalize_roles_type(sent_roles) & self.class.valid_roles).map { |r| 2**self.class.valid_roles.index(r) }.sum
  end

  def roles
    self.class.valid_roles.reject do |r|
      ((role_mask || 0) & 2**self.class.valid_roles.index(r)).zero?
    end
  end

  def is?(sent_roles)
    (roles & normalize_roles_type(sent_roles)).any?
  end

  def self.valid_roles
    ['admin', 'operator']
  end


  private 

  def generate_auth_token
    self.auth_token = SecureRandom.hex(10)
  end

  def normalize_roles_type(sent_roles)
    normal_roles = []
    normal_roles = sent_roles.map(&:to_s)  if sent_roles.is_a?(Array)
    normal_roles = sent_roles.split(' ').map(&:squish) if sent_roles.is_a? String
    normal_roles.push sent_roles.to_s if sent_roles.is_a? Symbol
    normal_roles
  end

  def there_is_one_admin
    if self.is?('admin') && self.class.admins.count == 1
      self.errors.add(:base, 'No puede eliminar todos los administradores') 
      false
    end
  end

  def ensure_has_no_carts
    if self.carts.completed.count.nonzero?
      self.errors.add(:base, 'Algunas ordenes hacen referencia a este agente') 
      false
    end
  end

end
