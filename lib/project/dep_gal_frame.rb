module DepGal
  class Project
    
      def create_image_versions
      # image reads in DepGal::Image
        @log.info("Building versions of image files: #{@standard_image_versions.collect{|i| "#{i[0]} (#{i[1]}px)" }.join(', ')}")


        @standard_image_versions.each_key do |version|
          v = "#{project_image_dir}/#{version}"

          if !File.exists?(v)
            @log.info("#{v} being created")
            FileUtils.makedirs(v)        
          end

        end

        @images.each do |image|
          image.create_versions(@standard_image_versions, project_image_dir)
        end

      end
      
  
  end
  
end
