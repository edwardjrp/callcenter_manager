(function( $ ){

  var methods = {
	  alpha : function(){
      $(this).on('keypress', function(event){
					if(event.which >= 97 && event.which <= 122) event.preventDefault();
			});
			$(this).on('blur', function(){
				  if($(this).val().match(/[a-z|A-Z]/g)) $(this).val('');
			});
	  },
		spaces : function(){
      $(this).on('keypress', function(event){
					if(event.which == 9 || event.which == 32) event.preventDefault();
			});
			$(this).on('blur', function(){
				  if($(this).val().match(/\s+/g)) $(this).val('');
			});
		},
    numeric : function(){
      $(this).on('keypress', function(event){
          if (event.which >= 48 && event.which <= 57) event.preventDefault();
      });
      $(this).on('blur', function(){
          if ($(this).val().match(/\[0-9]+/g)) $(this).val('');
      });
    }
  };

  $.fn.restric = function( method ) {
    // Method calling logic
    if ( methods[method] ) {
       methods[method].apply(this);
    } else {
      $.error( 'Method ' +  method + ' does not exist on jQuery.restric' );
    }    
  	return this
  };

})( jQuery );