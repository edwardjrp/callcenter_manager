# == Schema Information
#
# Table name: taxpayer_identifications
#
#  id            :integer          not null, primary key
#  idnumber      :string(255)
#  full_name     :string(255)
#  company_name  :string(255)
#  ocupation     :string(255)
#  street        :string(255)
#  street_number :string(255)
#  zone          :string(255)
#  other         :string(255)
#  start_time    :string(255)
#  state         :string(255)
#  kind          :string(255)
#

require 'spec_helper'

describe TaxpayerIdentification do
  pending "add some examples to (or delete) #{__FILE__}"
end
