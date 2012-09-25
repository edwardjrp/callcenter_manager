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

class TaxpayerIdentification < ActiveRecord::Base
  attr_accessible :company_name, :full_name, :idnumber, :kind, :ocupation, :other, :start_time, :state, :street, :street_number, :zone



  def self.upload(sent_file)
    target_file_name = sent_file['datafile'].original_filename
    directory = Rails.root.join("public/rnc")
    unless File.exists?(directory) && File.directory?(directory)
        Dir.mkdir(directory)
    end
    original_full_path = File.join(directory, target_file_name)
    File.open(original_full_path, "wb") { |f| f.write(sent_file['datafile'].read)}
    RncImporter.perform_async(original_full_path)
  end

  def self.find_tax_id(q)
    tax_ids = self.scoped
    tax_ids = tax_ids.merge(self.where('idnumber like ?', "#{q[:idnumber].downcase}%")) if q && q[:idnumber].present?
    tax_ids
  end
end
