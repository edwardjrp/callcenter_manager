(function( $ ){

  var methods = {
	  alpha : function(){
      $(this).keypress(function(event){
					if(event.which >= 97 && event.which <= 122) event.preventDefault();
			});	
	  }
  };

  $.fn.restric = function( method ) {
    // Method calling logic
    if ( methods[method] ) {
      return methods[method].apply();
    } else {
      $.error( 'Method ' +  method + ' does not exist on jQuery.restric' );
    }    
  	return this
  };

})( jQuery );