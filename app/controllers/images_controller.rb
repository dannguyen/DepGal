class ImagesController < ApplicationController
  def show
    @image = Image.find(params[:id])
  end

  def slideshow
    @images = Image.paginate :page => params[:page], :per_page => 7
  end
  
  def wall
    @images = Image.paginate :page => params[:page], :per_page => 30
    
  end
  
  def index
    @images = Image.paginate :page => params[:page], :per_page => 80
    respond_to do |format|
      format.html
      format.json{ render :json=>@images}
    end
  end
  
  def image_tag
    @image = Image.find(params[:id])
    @context = [:tag, params[:tag]]
    render :action=>:show
  end
  
  def images_tag
    @images = Image.tagged_with(params[:tag])
    @context = [:tag, params[:tag]]
    render :action=>:index
  end
end
