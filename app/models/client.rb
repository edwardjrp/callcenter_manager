class Client < ActiveRecord::Base
  attr_accessible :active, :email, :first_name, :idnumber, :last_name, :target_address_id, :target_phone_id
end
