function WallImage(opt){
	
	this.a_rect = opt.a_rect;
	this.a_url = opt.a_url;
	
	this.b_rect = opt.b_rect;
	this.b_url = opt.b_url;
	
	this.links = [null, null, null, null];
	this.embiggened = false;

}

function cropped_pos(w, h, crop_w, crop_h, orientation){
	// returns: 
	// {x:, y:, w:, h:}
	var obj = {};
	
//	if(w > crop_w){
		obj.w = crop_w;
		obj.h = crop_w/parseFloat(w) * h;
		obj.x = (crop_w-obj.w )/2.0;
		obj.y = (crop_h-obj.h)/2.0;
//	}
	return obj;
}

