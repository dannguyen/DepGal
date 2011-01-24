class ImageVersion
  attr_accessor :width, :height, :path, :name
  
  def initialize(nm, pth)
    @path = pth
    @name = nm
    @width, @height = FastImage.size("#{Rails.root.to_s}/public/#{@path}")
  end
  
  def exists?
    File.exists?(@path)
  end
  
end