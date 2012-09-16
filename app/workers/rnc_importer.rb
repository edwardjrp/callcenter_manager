# encoding: utf-8
require 'zip/zip'
require "csv"

class RncImporter
  include Sidekiq::Worker
  sidekiq_options retry: false
  
  def perform(target_file_path)
    import_log = ImportLog.create(log_type: ImportLog.rnc_import, state: 'Iniciando')
    x_paths = []
    normalize_csv_location = File.join(Rails.root.join("public/rnc"), 'dgii.nor')
    if File::exists?(target_file_path)
      if File.extname(target_file_path) == '.zip'
        x_paths = decompress(target_file_path, import_log)
      end
      unless x_paths.empty?
        normalize_csv(x_paths, import_log)
      end
      import(normalize_csv_location, import_log) if File.exist? normalize_csv_location
    else
      import_log.update_attributes(state: 'Falló')
    end
  end


 private 
 
 def decompress(file_to_decompress, import_log)
    import_log.import_events.create(name: 'Descomprimiendo archivo', subject: File.basename(file_to_decompress) , message: "Se inicio la descompreción del archivo #{file_to_decompress}")
    target_directory = Rails.root.join("public/rnc")
    x_paths = []
    Zip::ZipFile.open(file_to_decompress) do |zip_file|
      zip_file.each do |f|
        f_path=File.join(target_directory, f.name)
        FileUtils.mkdir_p(File.dirname(f_path))
        zip_file.extract(f, f_path) unless File.exist?(f_path)
        x_paths.push f_path 
      end
    end
    import_log.import_events.create(name: 'Descompreción completada', subject: File.basename(file_to_decompress) , message: "Se completo la descompreción del archivo #{file_to_decompress}")
    return x_paths
  end
 
 
  def normalize_csv(csv_path_list, import_log)
    import_log.import_events.create(name: 'Normalizando csv', subject: File.basename(csv_path_list[0]) , message: "Se inicio la normalización del archivo #{csv_path_list[0]}")
    unless csv_path_list.empty?
      original = csv_path_list[0] # will only import the first extrated file
      csv_file_target_location = File.join(Rails.root.join("public/rnc"), 'dgii.nor')
      CSV.open(csv_file_target_location, 'w',col_sep: "\|",:headers=> false) do |csv|  
        File.open(original, "r:ISO-8859-1") do |file|
          CSV.parse(file.read.gsub(/\"/,"*").encode("UTF-8"), col_sep: "\|",:headers=> false) do |row|
            csv << row.map{|field| field.gsub(/\x00/,"") unless field.nil?}
          end
        end
      end
      import_log.import_events.create(name: 'Complatada la normalización', subject: File.basename(csv_path_list[0]) , message: "Se normalizo el archivo #{csv_path_list[0]}")
    end
  end  
  
 
  def import(normalize_csv_location, import_log)
    if File::exists?(normalize_csv_location)
      begin
        import_log.import_events.create(name: 'Importando records', subject: File.basename(normalize_csv_location) , message: "Importando records a la base de datos")
        local_config = ActiveRecord::Base.configurations[Rails.env]
        import_log.import_events.create(name: 'Cargado configuración', subject: Rails.env , message: "Configurando conexion a la base de datos")
        config = {:host => local_config["host"], :dbname =>local_config["database"], :user =>(local_config["username"] || ''), :password=>(local_config["password"] || '')}
        conn = PGconn.open(config)
        import_log.import_events.create(name: 'Borrando datos actuales', subject: Rails.env , message: "Se estan borrando los datos desactualizados")
        conn.exec("TRUNCATE taxpayer_identifications")
        import_log.import_events.create(name: 'Copiando', subject: IO.readlines(normalize_csv_location).size , message: "Se estan importando #{IO.readlines(normalize_csv_location).size} records")
        conn.exec("copy taxpayer_identifications ( idnumber, full_name, company_name, ocupation, street, street_number, zone, other, start_time, state, kind )  from '#{normalize_csv_location}' WITH DELIMITER '|' csv")
        import_log.import_events.create(name: 'Completado', subject: TaxpayerIdentification.count , message: "Se estan importaron #{TaxpayerIdentification.count} records")
        import_log.update_attributes(state: 'Completado')
      rescue Exception => e
        import_log.import_events.create(name: 'Error al importar numeros fiscales hacia la base de datos', subject: File.basename(normalize_csv_location), message: e.message)
        import_log.update_attributes(state: 'Falló')
      end
    else
      import_log.update_attributes(state: 'Falló')
    end
  end
  
end