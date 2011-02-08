(function( $ ){
	
	var methods = {
		
		init : function(options){
			var settings={ image_div:'div.image_frame', thumbnail_width:150};
			
			return this.each(function() {            
			    if ( options ) { 
					$.extend( this, settings, options );
		      	}
				console.log("settings.thumbnail_width: " + settings.thumbnail_width)
			  	console.log("this.thumbnail_width: " + this.thumbnail_width);
				
				this.small_wall = $('<div id="small-wall" class="wall"></div>')
				$(this.image_div).wrapAll(this.small_wall)
				$(this.image_div).css({width:this.thumbnail_width, height:this.thumbnail_height, margin:this.thumbnail_margin, overflow:'hidden'})
				this.wall_images = [];
				
				
				for(var i = 0; i < $(this.image_div).length; i++ ){
					var img = $(this.image_div+":eq("+i+") img")
					
					var thumb = (img.wall_image(
						{
						a_rect: cropped_pos(img.width(), img.height(), this.thumbnail_width, this.thumbnail_height),
						a_url: img.attr("src"),
						a_test: 12
						}
					));
				
					
					thumb.click(
						function(){ console.log("Click: " + this.a_url )
					});


					this.wall_images.push(thumb);

				}

				console.log("setting height of wrapper");
				
			});	
		},
		//end of init
		test : function(){
			
		},
		
		center_on : function(){
			
		},
		
		
		
	};
	
	
	$.fn.wallie = function(method) {

		    // Method calling logic
		    if ( methods[method] ) {
		      return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
		    } else if ( typeof method === 'object' || ! method ) {
		      return methods.init.apply( this, arguments );
		    } else {
		      $.error( 'Method ' +  method + ' does not exist on jQuery.wallie' );
		    }

	  };
	
	
	/*
	this.image_div = opt.image_div
	this.thumbnail_width = opt.thumbnail_width;
	this.thumbnail_height = opt.thumbnail_height;
	
	this.thumbnail_margin = opt.thumbnail_margin;
	
	this.column_count = (this.width()-this.thumbnail_margin)/(this.thumbnail_width + this.thumbnail_margin)

	this.large_width = opt.large_width;
	this.large_height = opt.large_height;
	this.large_margin = opt.large_margin;
*/

	

	
	

})( jQuery );



///

///// wall_image
(function( $ ){
	var settings={ a_url:'http://google.com'};
	
	var methods = {
		init : function(options){
			
			return this.each(function() {            
			    if ( options ) { 
					$.extend( this, settings, options );
		      	}
				console.log("wall_image settings.a_url: " + settings.a_url)
			  	console.log("wall_image this.a_rect.x: " + this.a_rect.x);
				
				$(this).css({
						width: 	(this).a_rect.w,
						height: (this).a_rect.h,
						left: 	(this).a_rect.x,
						top: 	(this).a_rect.y
				})
				
				this.links = [null, null, null, null];
				this.embiggened = false;
			});
			
			
		}
	}


	$.fn.wall_image = function(method) {

		    // Method calling logic
		    if ( methods[method] ) {
		      return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
		    } else if ( typeof method === 'object' || ! method ) {
		      return methods.init.apply( this, arguments );
		    } else {
		      $.error( 'Method ' +  method + ' does not exist on jQuery.wall_image' );
		    }

	  };

})( jQuery );




function cropped_pos(w, h, crop_w, crop_h, orientation){
	// returns: 
	// {x:, y:, w:, h:}
	
	var obj = {};
	var r = {'w':w, 'h':h};
	var crop = {'w':crop_w, 'h':crop_h};
	
	var ax = w < h ? 'w' : 'h'
	var bx = ax=='w' ? 'h' : 'w'
	
	obj[ax] = crop[ax]
	obj[bx] = crop[ax]/parseFloat(r[ax]) * r[bx];
	obj.x = (crop_w-obj.w )/2.0;
	obj.y = (crop_h-obj.h)/2.0;
	

	return obj;
}



