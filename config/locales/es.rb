{
  "es"=>{
  "will_paginate"=>{ "previous_label"=>'Anterior', "next_label"=>"Siguiente","page_gap"=>"&hellip;"},
	"number"=>{
	"format"=>{
	"separator"=>",", "delimiter"=>".", "precision"=>3, "significant"=>false, "strip_insignificant_zeros"=>false}, 
	"currency"=>{
	"format"=>{
	"format"=>" %u %n", "unit"=>"RD$", "separator"=>".", "delimiter"=>",", "precision"=>2, "significant"=>false, "strip_insignificant_zeros"=>false}}, 
	"percentage"=>{
	"format"=>{
	"delimiter"=>""}}, 
	"precision"=>{
	"format"=>{
	"delimiter"=>""}}, 
	"human"=>{
	"format"=>{
	"delimiter"=>"", "precision"=>1, "significant"=>true, "strip_insignificant_zeros"=>true}, 
	"storage_units"=>{
	"format"=>"%n %u", "units"=>{
	"byte"=>{
	"one"=>"Byte", "other"=>"Bytes"}, 
	"kb"=>"KB", "mb"=>"MB", "gb"=>"GB", "tb"=>"TB"}}, 
	"decimal_units"=>{
	"format"=>"%n %u", "units"=>{
	"unit"=>"", "thousand"=>"Mil", "million"=>"Millón", "billion"=>"Mil millones", "trillion"=>"Trillón", "quadrillion"=>"Cuatrillón"}}}}, 
	"datetime"=>{
	"distance_in_words"=>{
	"half_a_minute"=>"medio minuto", "less_than_x_seconds"=>{
	"one"=>"menos de 1 segundo", "other"=>"menos de %{count} segundos"}, 
	"x_seconds"=>{
	"one"=>"1 segundo", "other"=>"%{count} segundos"}, 
	"less_than_x_minutes"=>{
	"one"=>"menos de 1 minuto", "other"=>"menos de %{count} minutos"}, 
	"x_minutes"=>{
	"one"=>"1 minuto", "other"=>"%{count} minutos"}, 
	"about_x_hours"=>{
	"one"=>"alrededor de 1 hora", "other"=>"alrededor de %{count} horas"}, 
	"x_days"=>{
	"one"=>"1 día", "other"=>"%{count} días"}, 
	"about_x_months"=>{
	"one"=>"alrededor de 1 mes", "other"=>"alrededor de %{count} meses"}, 
	"x_months"=>{
	"one"=>"1 mes", "other"=>"%{count} meses"}, 
	"about_x_years"=>{
	"one"=>"alrededor de 1 año", "other"=>"alrededor de %{count} años"}, 
	"over_x_years"=>{
	"one"=>"más de 1 año", "other"=>"más de %{count} años"}, 
	"almost_x_years"=>{
	"one"=>"casi 1 año", "other"=>"casi %{count} años"}}, 
	"prompts"=>{
	"year"=>"Año", "month"=>"Mes", "day"=>"Día", "hour"=>"Hora", "minute"=>"Minutos", "second"=>"Segundos"}}, 
	"helpers"=>{
	"select"=>{
	"prompt"=>"Por favor seleccione"}, 
	"submit"=>{
	"create"=>"Guardar %{model}", "update"=>"Actualizar %{model}", "submit"=>"Guardar %{model}"}}, 
	"formtastic"=>{
    "labels"=>{
      "user"=>{
        "name"=>"Nombres",
        "last_name"=>"Apellidos",
         "idnumber"=>"Cédula",
         "postal_code"=>"Codigo Postal",
         "unit_type"=>"Tipo de Residencia",
         "number"=>"Numero",
         "unit_number"=>"Numero de residencia"
      }
    },
    "actions"=>{
      "create"=>"Crear %{model}",
      "update"=>"Actualizar %{model}"
    }
  },
	"activerecord"=>{
	  "models"=>{
  	  "user"=>"Usuario",
  	  "coupon"=>"Cupon",
  	  "address"=>"Dirección",
  	  "category"=>"Categoría",
      "store"=>"Tienda",
      "product"=>"Producto"
  	   },
  	"attributes"=>{
  	  "client"=>{
  	    "first_name"=>"nombre",
  	    "idnumber"=>"cedula",
  	    "last_name"=>"apellido"
  	    },
  	    "address"=>{
    	    "kind"=>"tipo",
    	    "phone"=>"telefono",
    	    "zipcode"=>"codigo postal",
    	    "street"=>"calle",
    	    "number"=>"numero",
    	    "building"=>"edificio",
    	    "aptnumer"=>"numero de apartmento",
    	    "zone"=>"sector",
    	    "city"=>"ciudad"
    	    }
  	  },  
  	"errors"=>{
  	  "template"=>{
  	    "header"=>{
  	      "one"=>"No se pudo guardar este/a %{model} porque se encontró 1 error",
  	      "other"=>"No se pudo guardar este/a %{model} porque se encontraron %{count} errores"}, 
  	      "body"=>"Se encontraron problemas con los siguientes campos:"}, 
  	      "messages"=>{
  	        "inclusion"=>" no está incluido en la lista",
  	        "exclusion"=>" está reservado", 
  	        "invalid"=>" no es válido", 
  	        "confirmation"=>" no coincide con la confirmación", 
  	        "accepted"=>" debe ser aceptado", 
  	        "empty"=>" no puede estar vacío", 
  	        "blank"=>" no puede estar en blanco", 
  	        "too_long"=>" es demasiado largo (%{count} caracteres máximo)", 
  	        "too_short"=>" es demasiado corto (%{count} caracteres mínimo)", 
  	        "wrong_length"=>" no tiene la longitud correcta (%{count} caracteres exactos)", 
  	        "not_a_number"=>" no es un número", "greater_than"=>"debe ser mayor que %{count}", 
  	        "greater_than_or_equal_to"=>" debe ser mayor que o igual a %{count}", 
  	        "equal_to"=>" debe ser igual a %{count}", "less_than"=>"debe ser menor que %{count}", 
  	        "less_than_or_equal_to"=>" debe ser menor que o igual a %{count}", 
  	        "odd"=>" debe ser impar", 
  	        "even"=>" debe ser par", 
  	        "taken"=>" ya está en uso", 
  	        "record_invalid"=>" La validación falló: %{errors}"}, 
  	      "full_messages"=>{
  	          "format"=>"%{attribute} %{message}"
  	       }
  	      }
  	    }, 
  "errors"=>{
  	"format"=>"%{attribute} %{message}", "template"=>{
  	"header"=>{
  	"one"=>"No se pudo guardar este/a %{model} porque se encontró 1 error", "other"=>"No se pudo guardar este/a %{model} porque se encontraron %{count} errores"}, 
  	"body"=>"Se encontraron problemas con los siguientes campos:"}, 
  	"messages"=>{
  	"inclusion"=>"no está incluido en la lista", "exclusion"=>"está reservado", "invalid"=>"no es válido", "confirmation"=>"no coincide con la confirmación", "accepted"=>"debe ser aceptado", "empty"=>"no puede estar vacío", "blank"=>"no puede estar en blanco", "too_long"=>"es demasiado largo (%{count} caracteres máximo)", "too_short"=>"es demasiado corto (%{count} caracteres mínimo)", "wrong_length"=>"no tiene la longitud correcta (%{count} caracteres exactos)", "not_a_number"=>"no es un número", "greater_than"=>"debe ser mayor que %{count}", "greater_than_or_equal_to"=>"debe ser mayor que o igual a %{count}", "equal_to"=>"debe ser igual a %{count}", "less_than"=>"debe ser menor que %{count}", "less_than_or_equal_to"=>"debe ser menor que o igual a %{count}", "odd"=>"debe ser impar", "even"=>"debe ser par"}
	}, 
	"faker"=>{
    "phone_number"=>{
      "formats"=>['809 ### ####','829 ### ####','849 ### ####','(809)-###-####','829-###-####','849#######']
      }
    },
	"date"=>{
	"formats"=>{
	"default"=>"%d/%m/%Y", "short"=>"%d de %b", "long"=>"%d de %B de %Y"}, 
	"day_names"=>["Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"], "abbr_day_names"=>["Dom", "Lun", "Mar", "Mie", "Jue", "Vie", "Sab"], "month_names"=>[nil, "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"], "abbr_month_names"=>[nil, "Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"], "order"=>[:day, :month, :year]}, 
	"time"=>{
	"formats"=>{
	"default"=>"%A, %d de %B de %Y %H:%M:%S %z", "short"=>"%d de %b %H:%M", "long"=>"%d de %B de %Y %H:%M"}, 
	"am"=>"am", "pm"=>"pm"}, 
	"support"=>{
	"array"=>{
	"words_connector"=>", ", "two_words_connector"=>" y ", "last_word_connector"=>" y "}, 
	"select"=>{
	"prompt"=>"Por favor seleccione"}}}
}