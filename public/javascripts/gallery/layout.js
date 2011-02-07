jQuery(document).ready(function(){

	jQuery("div.image img").css('opacity', '0');
	jQuery("div.image img").bind("load", function () { $(this).animate({opacity:1.0}) });

/*

	jQuery("#images-wrapper").masonry({
		singleMode: false,
		columnWidth: 200,
		resizeable: false,
  
	  //	appendedContent: jQuery('.photo'),

		itemSelector: 'div.image'
	})
*/	
	
	//jQuery("a[rel='cbox']").colorbox({transition:"fade", opacity:0.7, width:'70%'});
	
})