	jQuery(document).ready(function(){
	
		jQuery("#photos-wrapper").masonry({
			singleMode: false,
			columnWidth: 160,
			resizeable: false,
		  
		  //	appendedContent: jQuery('.photo'),
		
			itemSelector: '.photo'
		})
		
	//	console.log("masoned");
		
		$("a[rel='cbox']").colorbox({transition:"fade", opacity:0.7});
		
		
		$("div.photo img").one('load', function(){
			var q = Math.ceil(1200.0 * Math.random()) + 400
		    $(this).fadeIn(q, 'easeInOutExpo');
		  }).each(function(){
			if(this.complete || (jQuery.browser.msie && parseInt(jQuery.browser.version) == 6)) 
			$(this).trigger("load");
			});

		$("div.menu-item img").one('load', function(){
			$(this).parent().parent().hide()
			var q = Math.ceil(1200.0 * Math.random()) + 400
		    $(this).parent().parent().fadeIn(q, 'easeInOutExpo');
		  }).each(function(){
			if(this.complete || (jQuery.browser.msie && parseInt(jQuery.browser.version) == 6)) 
			$(this).trigger("load");
			});

		
		$(".photo").hover(function(){
		   $(this).animate({ backgroundColor: "#444447" }, 200);
		},function() {
		    $(this).animate({ backgroundColor: "#1a1a1f" }, 200);
		});
		

		$("a.menu-link").hover(function(){
		   $(this).next(".menu-item").find('img').animate({ opacity: 0.0 }, 200);
		},function() {
		    $(this).next(".menu-item").find('img').animate({ opacity: 1.0 }, 200);
		});

		
		$(".menu-item img").hover(function(){
		   $(this).animate({ opacity: 0.0 }, 200);
		},function() {
		    $(this).animate({ opacity: 1.0 }, 200);
		});
		

	})	
