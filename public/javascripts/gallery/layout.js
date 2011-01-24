jQuery(document).ready(function(){

	jQuery("#images-wrapper").masonry({
		singleMode: false,
		columnWidth: 200,
		resizeable: false,
  
	  //	appendedContent: jQuery('.photo'),

		itemSelector: 'div.image'
	})
	
	//jQuery("a[rel='cbox']").colorbox({transition:"fade", opacity:0.7, width:'70%'});
	
})