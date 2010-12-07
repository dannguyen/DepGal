
#convenience methods
module DepGal
  class Project
    def root_path
      File.expand_path(@config['directories']['rootPath'])
    end

    def source_image_dir
      "#{root_path}/#{@config['directories']['sourceImageDir']}"
    end

    def project_dir
      "#{root_path}/#{@config['directories']['projectDir']}"
    end
 
   def project_image_dir
     "#{project_dir}/images" 
   end
   
   def project_gallery_dir
     "#{project_dir}/gallery"
   end

   def initial_dirs
     {'Root path'=>root_path, 'Source directory for images'=>source_image_dir}
   end

   def project_dirs
     {'Project directory'=>project_dir, 'Project images directory'=>project_image_dir, 'Project gallery directory'=>project_gallery_dir}
   end

   def image_list_filename 
     "#{project_dir}/image_list.yml"
   end
 
 
   def gallery_width
     @config['gallery']['width'].to_i
   end
 
   def gallery_columns
     @config['gallery']['columns']['number'].to_i
   end

   def gallery_columns_margin
     @config['gallery']['columns']['margin'].to_i
   end
 
   ### image attributes
 
 
   def image_viewer_width
     g = @config['gallery']['imageViewerWidth'].to_i
     g > 0 ?  gallery_width : g.to_i
   end


   def thumbnail_width
     w = ((gallery_width-(gallery_columns-1)*gallery_columns_margin)/gallery_columns).floor
   end
   
 end
end