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
end
