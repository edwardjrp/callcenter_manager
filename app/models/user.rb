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
  validates :idnumber, presence: true, uniqueness: true
  attr_accessible :first_name, :last_name, :idnumber, :username, :password, :password_confirmation
  before_validation :generate_auth_token
  
  def self.authenticate(username, password)
      find_by_username(username).try(:authenticate, password)
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def generate_auth_token
    self.auth_token = SecureRandom.hex(10)
  end
end
