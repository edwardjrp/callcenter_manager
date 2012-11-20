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

require 'spec_helper'

describe User do
  describe 'Validations' do
    before { create :user, :username=> 'test', :password=>'please' }
    
    it { should validate_presence_of :username }
    it { should validate_uniqueness_of :username }
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
    it { should validate_presence_of :idnumber }
    it { should ensure_length_of(:idnumber).is_equal_to(11) }
    it { should_not validate_presence_of :role_mask }
    it { should validate_uniqueness_of(:idnumber).scoped_to(:role_mask) }
    it { should validate_confirmation_of :password }
    it { should allow_mass_assignment_of :active }
    it { should_not allow_mass_assignment_of :role_mask }
    it { should_not allow_mass_assignment_of :last_action_at }
    it { should_not allow_mass_assignment_of :login_count }
    it { should_not allow_mass_assignment_of :password_digest }
    it { should_not allow_mass_assignment_of :auth_token }

  end
  
  describe "generate auth_token" do
    let!(:user) { build(:user, username: 'test', first_name: 'tester', last_name:'test_last', password: 'please', idnumber: '00113574339') }

    it "should generate the auth token for a new user" do
      user.should be_valid
      user.save
      user.auth_token.should_not be_nil
    end

  end
  
  describe '#there_is_one_admin' do
    let!(:admin) { create :user, roles: :admin }

    it "should not allow the deletion of the last admin" do
      expect{ admin.destroy }.to_not change{ User.admins.count }.from(1).to(0)
    end

  end

  
  describe "roles behavior" do
    
    let!(:user) { build :user, :operator }
    let!(:admin) { build :user,  :admin }
  
    it "should respond to role" do
      User.should respond_to(:valid_roles)
    end
    
    it "should respond to role" do
      user.should respond_to(:roles)
    end
    
    it "should be an admin" do
      admin.roles.should include('admin')
    end
    
    it "should be an operator" do
      user.roles.should include('operator')
    end
    
  end
end
