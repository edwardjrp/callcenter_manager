# #encoding: utf-8
require 'csv'
# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# #
# # Examples:
# #
# #   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
# #   Mayor.create(name: 'Emanuel', city: cities.first)
FactoryGirl.create :user, :password=>'please', :password_confirmation=>'please', :username=>'test', :roles=> [:operator]
FactoryGirl.create :user, :password=>'please', :password_confirmation=>'please', :username=>'admin', :roles=> [:admin]
100.times do
  FactoryGirl.create :phone
end


def save_without_massasignment(model, attributes={})
    instance = model.new
    instance.assign_attributes(attributes)
    instance.save!
    return instance
end

puts "adding stores"
save_without_massasignment(Store,{:name=>"Sarasota",:address=>"Av. Sarasota No. 110, Bella Vista",:ip=>"192.168.65.2",:storeid=>"15875",:city_id =>City.find_or_create_by_name("Santo Domingo").id})
save_without_massasignment(Store,{:name=>"Venezuela",:address=>"Av. Venezuela Esq. Club de Leones, Ens. Ozama",:ip=>"192.168.68.2",:storeid=>"15879",:city_id =>City.find_or_create_by_name("Santo Domingo").id})
save_without_massasignment(Store,{:name=>"San Isidro",:address=>"Aut. San Isidro, Plaza Palmeras, Urb. Italia",:ip=>"192.168.69.2",:storeid=>"15892",:city_id =>City.find_or_create_by_name("Santo Domingo").id})
save_without_massasignment(Store,{:name=>"Plaza Central",:address=>"Plaza Central: Av. 27 de Febrero esq. Winston Churchill, Food Court, 2do. Nivel.",:ip=>"192.168.82.2",:storeid=>"15899",:city_id =>City.find_or_create_by_name("Santo Domingo").id})
save_without_massasignment(Store,{:name=>"Gazcue",:address=>"Av. Máximo Gómez No. 65, Plaza D\'Agostini",:ip=>"192.168.64.2",:storeid=>"15873",:city_id =>City.find_or_create_by_name("Santo Domingo").id})
save_without_massasignment(Store,{:name=>"La Romana",:address=>"C/ Francisco Castillo Marquez casi esq. Duarte",:ip=>"192.168.60.2",:storeid=>"15898",:city_id =>City.find_or_create_by_name("La Romana").id})
save_without_massasignment(Store,{:name=>"El Embrujo",:address=>"Aut. Duarte Km. 2 1/2, El Embrujo",:ip=>"192.168.72.2",:storeid=>"15874",:city_id =>City.find_or_create_by_name("Santiago").id})
save_without_massasignment(Store,{:name=>"Duarte",:address=>"Carr. Nagua, Km 2 1/2 La Sirena.",:ip=>"192.168.75.2",:storeid=>"15894",:city_id =>City.find_or_create_by_name("San Francisco de Macoris").id})
save_without_massasignment(Store,{:name=>"Colinas Mall",:address=>"Av. 27 de Febrero, Plaza Colinas Mall",:ip=>"192.168.76.2",:storeid=>"15900",:city_id =>City.find_or_create_by_name("Santiago").id})
save_without_massasignment(Store,{:name=>"Bartolome Colon",:address=>"Sirena Pola, C/ Bartolomé Colón esq. German Soriano",:ip=>"192.168.77.2",:storeid=>"15889",:city_id =>City.find_or_create_by_name("Santiago").id})
save_without_massasignment(Store,{:name=>"Los Jardines",:address=>"Av. 27 de Febrero, Plaza El Paseo",:ip=>"192.168.79.2",:storeid=>"15876",:city_id =>City.find_or_create_by_name("Santiago").id})
save_without_massasignment(Store,{:name=>"Lope de Vega",:address=>"Av. Lope de Vega No. 47, Plaza Asturiana",:ip=>"192.168.61.2",:storeid=>"15881",:city_id =>City.find_or_create_by_name("Santo Domingo").id})
save_without_massasignment(Store,{:name=>"Puerto Plata",:address=>"Av. General Gregorio Luperon esq. 16 de agosto, 1er . Nivel Multicentro La Sirena.",:ip=>"192.168.86.2",:storeid=>"15901",:city_id =>City.find_or_create_by_name("Puerto Plata").id})
save_without_massasignment(Store,{:name=>"Centro Plaza",:address=>"Internacional  Av. Juan Pablo Duarte esq. C/ Ponce",:ip=>"192.168.78.2",:storeid=>"15891",:city_id =>City.find_or_create_by_name("Santiago").id})
save_without_massasignment(Store,{:name=>"Charles de Gaulle",:address=>"Multicentro La Sirena, Av. Charles de Gaulle",:ip=>"192.168.81.2",:storeid=>"15887",:city_id =>City.find_or_create_by_name("Santo Domingo").id})
save_without_massasignment(Store,{:name=>"Arroyo Hondo",:address=>"C/ Luis Amiama Tió No. 66, Plaza Karina, Arroyo Hondo",:ip=>"192.168.35.252",:storeid=>"15871",:city_id =>City.find_or_create_by_name("Santo Domingo").id})
save_without_massasignment(Store,{:name=>"Mella",:address=>"Carr. Mella Km. 6 1/2 , Plaza Paola",:ip=>"192.168.71.2",:storeid=>"15880",:city_id =>City.find_or_create_by_name("Santo Domingo").id})
save_without_massasignment(Store,{:name=>"Las Colinas",:address=>"Av. 27 de Febrero No. 400, Plaza Cibao",:ip=>"192.168.80.2",:storeid=>"15870",:city_id =>City.find_or_create_by_name("Santiago").id})
save_without_massasignment(Store,{:name=>"Villa Mella",:address=>"Av. Charles de Gaulle, Esq. Hermanas Mirabal. La Sirena.",:ip=>"192.168.87.2",:storeid=>"15902",:city_id =>City.find_by_name("Santo Domingo").id})
save_without_massasignment(Store,{:name=>"Costa Caribe",:address=>"Km. 9 1/2 Carr. Sánchez, Costa Caribe",:ip=>"192.168.66.2",:storeid=>"15888",:city_id =>City.find_or_create_by_name("Santo Domingo").id})
save_without_massasignment(Store,{:name=>"Nunez de Caceres",:address=>"Av. Núñez de Cáceres, Plaza Saint Michell",:ip=>"192.168.67.2",:storeid=>"15872",:city_id =>City.find_or_create_by_name("Santo Domingo").id})
save_without_massasignment(Store,{:name=>"San Pedro de Macoris",:address=>"Centro Nacional del Este",:ip=>"192.168.83.2",:storeid=>"15895",:city_id =>City.find_or_create_by_name("San Pedro de Macoris").id})
save_without_massasignment(Store,{:name=>"Mega Centro",:address=>"Megacentro, Av. San Vicente de Paúl",:ip=>"192.168.70.2",:storeid=>"15893",:city_id =>City.find_or_create_by_name("Santo Domingo").id})
save_without_massasignment(Store,{:name=>"Tienda Virtual OLO",:address=>"Dominos cc",:ip=>"192.168.85.4",:storeid=>"99999",:city_id =>City.find_or_create_by_name("Santo Domingo").id})
save_without_massasignment(Store,{:name=>"La Vega",:address=>"Av. García Godoy esq. Balilo Gómez, Plaza Michelle",:ip=>"192.168.74.2",:storeid=>"15885",:city_id =>City.find_or_create_by_name("La Vega").id})

puts "adding addresses"
addresses_data_file = Rails.root.join("tmp","direcciones.csv")
if File.exists? addresses_data_file
  CSV.foreach(addresses_data_file, :quote_char => '"', :col_sep =>'|', :headers =>true) do |row|
    if row.fields.length == 3
      # puts "**************"
      # puts row.fields.first.match(/(?:.+),(.+),(?:.\d+)/)[1] unless row.fields.first.match(/(?:.+),(.+),(?:.\d+)/).nil?
      # puts row.fields[1]
      # puts row.fields
      # puts "=============="
      current_city = City.find_by_name(row.fields.last)
      current_store = Store.find_by_storeid(row.fields[1]) if row.fields[1].present?
      unless row.fields.first.match(/(?:.+),(.+),(?:.\d+)/).nil?
        Area.create do |area|
          # puts row.fields.first.match(/(?:.+),(.+),(?:.\d+)/)[1]
          area.name = row.fields.first.match(/(?:.+),(.+),(?:.\d+)/)[1].strip
          area.city_id = current_city.id if current_city.present?
          area.store_id = current_store.id if current_store.present?
        end
      end
      unless row.fields.first.match(/(.+),(?:.+),(?:.\d+)/).nil?
        current_area = Area.find_by_name(row.fields.first.match(/(?:.+),(.+),(?:.\d+)/)[1].strip)
        # puts current_area.inspect if current_area
        # puts row.fields.first.match(/(?:.+),(.+),(?:.\d+)/)
        Street.create do |street|
          street.name = row.fields.first.match(/(.+),(?:.+),(?:.\d+)/)[1].strip
          street.area_id = current_area.id if current_area.present?
        end
      end
    end
  end
end

puts "adding categories and products"
temp_products_file = Rails.root.join("tmp","15871_get_store_products.xml")
if File.exists?(temp_products_file)
  product_file_data = File.open(temp_products_file, 'r:utf-8').read
  doc= Nokogiri::XML(product_file_data)
  products_table = doc.css('Products').first.inner_text.gsub(/"/,'&quot;')
  CSV.parse(products_table, {:col_sep=>"\t", :headers=>true}) do |row|
    Product.create do |product|
      # puts "#{row['CategoryCode']} > #{row['ProductCode']} - #{row['ProductName']}"
      product.category_id = Category.find_or_create_by_name(row['CategoryCode']).id
      product.productcode = row['ProductCode']
      product.productname = row['ProductName']
      product.options = row['Options']
      product.sizecode = row['SizeCode']
      product.flavorcode = row['FlavorCode']
      product.optionselectiongrouptype = row['OptionSelectionGroupType']
      product.productoptionselectiongroup = row['ProductOptionSelectionGroup']
    end
  end
end
