var column_count = 4;

var small_mode = {div:"#small-wall", img_width:150, img_height:100, margin:10}
	small_mode.width_max = column_count * (small_mode.img_width+small_mode.margin*2 ) + small_mode.margin*2
	
var large_mode = {div:"#large-wall", img_width:800, img_height:600, margin:15}
	large_mode.width_max = column_count * (large_mode.img_width+large_mode.margin*2 ) + large_mode.margin*2
	
	
var images_wall, images_wrapper;


jQuery(document).ready(function(){
	
	// initialize image size
	
	$("div.image").css({width:small_mode.img_width, margin:small_mode.margin})
	$("div.image img").css({width:small_mode.img_width})
	$("div.image").click(function(){ fooEnlarge($(this))});
	
	///
	
	images_wrapper = jQuery("#images-wrapper");
	images_wrapper.css("height", jQuery(window).height())
	
	
	small_mode.wall = jQuery(small_mode.div);		
	small_mode.wall.css("width", small_mode.width_max);
	/*jQuery("#somebutton").click(function(){
		
		
		$.ajax({
		  url: "<%=url_for({:controller=>'images', :action=>'index', :format=>'json'})%>",
		  dataType: "json",
	   
		  success: function(images) {
		    	
				jQuery("#result").append("Hello " + images.length)
				
				
				for(var i = 0; i<images.length; i++){
					var image = images[i];
					small_mode.wall.append("<div class=\"image\" style=\"width:"+small_mode.img_width+"px; height:"+small_mode.img_height+"px;\"><img  style=\"width:"+small_mode.img_width+"px; height:"+small_mode.img_height+"px;\" src=\""+image.thumbnail.path+ "\" /></div>")
					
				}
				
				
				
				
				
		  }
		});
		
		
	})*/
})


function fooEnlarge(jimg){
	console.log("Scrolling to: " + jimg.find("img").attr("src"));
//	$("div.image").animate({width:800, height:500}, 800)
//	$("div.image").find('img').animate({width:800, height:500}, 800)
	
	//images_wrapper.scrollTo(jimg, 800)
	
	var jleft = jimg.position().left + jimg.width()/2;
	var jtop = jimg.position().top + jimg.height()/2;
	
	var oleft = small_mode.wall.offset().left;
	var otop = small_mode.wall.offset().top;
	
	var wmidpoint = images_wrapper.width()/2;
	var hmidpoint = images_wrapper.height()/2;

	//center
	small_mode.wall.animate({left: (wmidpoint-jleft), top:(hmidpoint-jtop)}, 
	{
		duration: 1000,
		complete: function(){
			
			var jindex= jimg.index();
		//	fooDarkenImages(jindex);
			small_mode.wall.animate({width: large_mode.width_max}, 1000);
			
			//jQuery("div.image, div.image img")
			
			jQuery("div.image:eq("+jindex+"), div.image:eq("+jindex+") img").animate({width:large_mode.img_width, height:large_mode.img_height},
				{
					duration: 1000,
					step: function(){
						small_mode.wall.css(
							{
								left: wmidpoint - (jimg.position().left + jimg.width()/2),
								top: hmidpoint - (jimg.position().top + jimg.height()/2)
							} 
						);
					}
					
				}
			)
		}
		
	}) 
	 
	//enlarge small wall
	
	
	
	/*	,{	
		duration: 800, 
	
		complete: function(){
			
			small_mode.wall.animate({width: 10000},
				
				{duration:1000,
					step: function(){
						small_mode.wall.css
						small_mode.wall.css("left")
					}
				
				})
			
		}
		
	});
	*/
}

function fooDarkenImages(except_this_i){
	var images_array = jQuery("div.image")
	console.log(except_this_i + " << lookee")
	for(var i=0; i< images_array.length; i++){
		
		if(i == except_this_i){
			jQuery(images_array[i]).removeClass('hidden')
		}else{
			jQuery(images_array[i]).addClass('hidden')
		}
		/*
		if( Math.abs(i-except_for_i) <= 1 ){
			jQuery(images_array[i]).find("img").css("visibility", "visible");
		}else{
			jQuery(images_array[i]).css("visibility", "hidden");
		}	*/
		
	}
}