#encoding:utf-8
module Admin::ImportLogsHelper

  def humanize_import_type(import_type)
    ['Importación de productos', 'Importación de cupones', 'Importación de numeros fiscales'][ImportLog.log_types.index(import_type)]
  end
end
