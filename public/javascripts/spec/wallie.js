(function( $ ){

  $.fn.wallie = function(opt) {
	this.image_div = opt.image_div
	this.thumbnail_width = opt.thumbnail_width;
	this.thumbnail_height = opt.thumbnail_height;
	
	this.thumbnail_margin = opt.thumbnail_margin;
	
	this.column_count = (this.width()-this.thumbnail_margin)/(this.thumbnail_width + this.thumbnail_margin)

	this.large_width = opt.large_width;
	this.large_height = opt.large_height;
	this.large_margin = opt.large_margin;

	this.small_wall = $('<div id="small-wall" class="wall"></div>')
	$(this.image_div).wrapAll(this.small_wall)
	$(this.image_div).css({width:this.thumbnail_width, height:this.thumbnail_height, margin:this.thumbnail_margin, overflow:'hidden'})
		

	this.wall_images = [];
	
	for(var i = 0; i < $(this.image_div).length; i++ ){
		var img = $(this.image_div+":eq("+i+") img");
		var w_img = new WallImage({
			a_rect: cropped_pos(img.width(), img.height(), this.thumbnail_width, this.thumbnail_height),
			a_url: img.attr("src")
		});
		
		w_img.thumbnail= img;
		
		w_img.thumbnail.css({
			width:w_img.a_rect.w(),
			height:w_img.a_rect.h(),
			left: w_image.a_rect.x(),
			top: w_image.a_rect.y()
		})
		
		
		this.wall_images.push(w_img);
	}
	
	console.log("setting height of wrapper");
	
	
	

  };
})( jQuery );

