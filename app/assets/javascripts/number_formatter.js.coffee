class @NumberFormatter 
	@to_phone = (raw_phone)->
		raw_phone.replace(/\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})/g, "$1-$2-$3")
	@to_id = (raw_id)->
		raw_id.replace(/\(?([0-9]{3})\)?[-. ]?([0-9]{7})[-. ]?([0-9]{1})/g, "$1-$2-$3")
	@to_clear = (formatter_number) ->
		formatter_number.replace(/[-. ]/g,'')