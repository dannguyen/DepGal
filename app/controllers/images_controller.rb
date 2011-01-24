class ImagesController < ApplicationController
  def show
    @image = Image.find(params[:id])
  end

  def index
    @images = Image.all
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
