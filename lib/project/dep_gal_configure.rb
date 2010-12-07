module DepGal
  class Project
    
    
    def read_config
      @log.info("Reading configuration")
      @config = read_yaml(@config_filename, {:validate_keys=>['directories', 'meta', ['directories','rootPath']]})
      
      initial_dirs.each_pair{|k,v| 
        d = "#{k}: #{v}"
        if File.exists?(v)
          @log.info(d)
        else
          raise Exception, "#{d} doesn't exist!"
        end
      }
      
      # calculating standard_image_versions
      @standard_image_versions = {'thumbnail'=>{'width'=>thumbnail_width}, 'large'=>{'width'=>image_viewer_width}}
      
      @standard_image_versions.each_pair do |k,v|
        @log.info("Image versions: #{k} - #{v}")
      end
      
      @config
    end
    
  end
end