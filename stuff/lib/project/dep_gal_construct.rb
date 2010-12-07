module DepGal
  class Project
    
    
    def construct_directories
      @log.info("Building directories")
      project_dirs.each_pair do |k,v|
        m = "#{k}: #{v}"
        puts "\n\n***#{m}"
        if File.exists?(v)
          @log.info("#{m} already exists")
        else
          @log.info("#{m} being created")
          FileUtils.makedirs(v)  
        end    
      end
    end
    
    def construct_image_list
      @log.info("Build image list")
      # image_list_filename resides in the project root directory
      
      # check existence of image_list_filename and overwrite it if
      # directed to do so
      if File.exists?(image_list_filename) && !@options[:overwrite_image_list]==true
        @log.info("#{image_list_filename} exists")
        @images = load_image_list()
        
        # parse yaml if exists
      else
        
        @log.info("#{image_list_filename} being created")
        image_filenames = fuf_glob_all_set(source_image_dir, 
        (@options[:file_extensions].blank? ? @@PHOTO_FILE_EXT : @options[:file_extensions] ))
        @log.info("#{image_filenames.length} found:\n")
        
        @images = image_filenames.inject([]){|a, fname|
          @log.info("Image File: #{fname}")
          rimage = DepGal::ImageEntry.new(fname)
          rimage.init_process
          a << rimage
        }
        
        write_image_list()
      end
      
    end
    
  
  
  end
  
end
