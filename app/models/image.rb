require 'image_version.rb'
class Image < ActiveRecord::Base
  
  
  validates_uniqueness_of :source_path # to be taken out with paperclip
  before_destroy :clear_dirs
  acts_as_taggable 
  attr_accessor :versions
  
  @@styles = IMAGE_STYLES.map{|s| s[0]}
  @@versions = []

  
  def self.styles
    @@styles
  end
  
  def self.versions
    @@versions
  end
  
 def name
   title
 end
 
 
 
 def base_filename
   File.basename(source_path)
 end
 
 
 def storage_dir
   "#{IMAGE_STORAGE_PATH}/#{self.id}"
 end
 
 
 def style_dir(stylename, opt={})
   "#{"#{Rails.root.to_s}/public" if opt[:abs]==true}#{storage_dir}/#{stylename}"
 end
 
 
 def style_path(stylename=nil, opt={})
   if !stylename
     Dir["#{storage_dir}/"]
   else
     "#{style_dir(stylename, opt)}/#{base_filename}"
   end
   
   #self.send("#{stylename}_path", opt) if self.respond_to?("#{stylename}_path")
 end
 
 
 
 def thumbnail_path(size=nil, opt={})
=begin
   e = size.to_i
   for i in 0..e
     return self.send("thumb_#{e-i}_path", opt) if self.respond_to?("thumb_#{e-i}_path")
   end
   return self.send("thumb_path", opt) if self.respond_to?("thumb_path")
=end
 end
 
 def thumbnail(size=nil, opt={})
  e = size.to_i
  for i in 0..e
    return self.send("thumb_#{e-i}", opt) if self.respond_to?("thumb_#{e-i}")
  end
  return self.send("thumb", opt) if self.respond_to?("thumb")
  
 end
 
 @@styles.each do |style|
   define_method("#{style}") do |*args|
     opt = args[0].blank? ? {} : args[0]
     #"#{style_dir(style, opt)}/#{base_filename}"
     ImageVersion.new(style, "#{style_dir(style, opt)}/#{base_filename}")
   end
   @@versions << style
   
 end
 
 
 private 
 def clear_dirs
   dir =  "#{storage_dir}"

   Dir.glob("#{dir}/**/*.{#{['jpg','JPG']}}").each do |file|
     File.delete(file)
   end
   Dir["#{dir}/**/"].select { |d| File.directory? d }.select { |d| (Dir.entries(d) - %w[ . .. ]).empty? }.each   { |d| Dir.rmdir d }
   
   
   puts "Dirs cleared: #{dir}"
   
   
 end
 
 
 
 
end
