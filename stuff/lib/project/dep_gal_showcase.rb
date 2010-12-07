module DepGal
  class Project
    def make_page_from_image_set(images, opt={})
      puts "Make Pages stub"
      DepGal::Template.make_gallery_page(images.map{|i| i.att_hash['thumbnail']}, opt)
    end
    
  end
end