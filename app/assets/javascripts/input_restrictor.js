(function( $ ){

  var methods = {
	  alpha : function(){
      $(this).keypress(function(event){
					if(event.which >= 97 && event.which <= 122) event.preventDefault();
			});
			$(this).blur(function(){
				  if($(this).val().match(/[a-z|A-Z]/g)) $(this).val('');
			});	
	  }
  };

  $.fn.restric = function( method ) {
    // Method calling logic
    if ( methods[method] ) {
      return methods[method].apply(this);
    } else {
      $.error( 'Method ' +  method + ' does not exist on jQuery.restric' );
    }    
  	return this
  };

})( jQuery );