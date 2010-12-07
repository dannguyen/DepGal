require 'rubygems'
require 'rmagick'

class RagImage 
  #a wrapper for Magick::Image
  attr_accessor :filename
  #attr_accessor :img, :imgq  
  
  #alias :image :img
  @@IMAGE_INFO = %W[format columns rows depth number_colors filesize]
  @@WORKING_SCALE= 0.1;
  
  def initialize(file_name)
   # puts "Initializing"
    @filename = file_name
    #puts "RagImage: Opening #{@filename}"
    @_img = build()
   # show_info(@_img)
    
  end
  
  def img
    @_img
  end
  
  def build(fn=@filename)
    @_img = Magick::Image::read(fn).first
  end
  
  def destroyed?
    @_img.destroyed?
  end

  def exif(to_hash=true)
    x = @_img.get_exif_by_entry
    if to_hash==true
      x = x.inject({}){|h,v|
        h[v[0]] = v[1]
        h
      }
    end
    x
  end

  def show_info(an_image)
    unless an_image.nil?
      @@IMAGE_INFO.each{|i| puts "#{i}: #{an_image.send(i)}\n"}
    end
  end
  
  def collapse
    # reduce file for analysis
    @_imgq = @_img.resize(@@WORKING_SCALE).quantize(256, Magick::GRAYColorspace)
    #@_imgq = @_imgq.
  end
  
  def create_image(path, opt={})
    imgn = @_img.clone
    imgn.resize_to_fit!(opt[:width]) if opt[:width].to_i > 0
    imgn.write(path)
  end
  
  def output(outname, imgn = nil)
    imgn = @_img if imgn.nil? || !imgn.is_a?(Magick::Image)
   # puts "Created #{outname}"
    show_info(imgn)
    imgn.write(outname)
    
  end
  

end