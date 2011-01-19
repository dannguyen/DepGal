jQuery(document).ready(function(){

	jQuery("#images-wrapper").masonry({
		singleMode: false,
		columnWidth: 200,
		resizeable: false,
  
	  //	appendedContent: jQuery('.photo'),

		itemSelector: 'div.image'
	})
})