load 'rag_mag/rag_image.rb'

module DepGal

  class Image #not to be confused with class RagImage
    attr_accessor :base_filename, :base_subdir, :source_filename
    attr_accessor :source_path, :export_path
    attr_accessor :versions
   
    attr_accessor :metadata
   
    attr_accessor :rag_image
     # private :rag_image 
    
    def initialize(s_name)
      @source_filename = s_name
      @base_filename = File.basename(@source_filename)
      @source_path = File.dirname(@source_filename)
      
     # @base_subdir = "#{sub_dir}/"
      
     # @export_path = x_path
      @versions = ['original']
      @metadata = {}
    end
    
    def init_process
      @rag_image=RagImage.new(self.source_filename)
      @rag_image.build
      @metadata['exif'] = (@rag_image.exif)
    end
    
    def rag_image_exists?
      !@rag_image.blank? && !@rag_image.destroyed?
    end
    
    def destroyed?
      !rag_image_exists?
    end
    
    
    def export_versions
      # reads versions and exports files
      @versions.each do |version|
        export_image_version(version)
      end
    end
    
    def export_original
      # read from original file and output to the export_path
      export_image_version('original')
    end
    
    def export_image_version(version)
      version_dir = "#{@export_path}/#{version}/#{@base_subdir}"
      fuf_maked_dirs(version_dir) unless File.exists?(version_dir)
      @rag_image.output("#{version_dir}/#{@base_filename}")      
    end

    def build
      init_process
      export_original
    end
    
    
    #convenience methods
    def original_filename 
      "#{@source_path}/#{@base_filename}"
    end
    
    def relative_path
      "#{@base_subdir}/#{@base_filename}"
    end
    
    
  end
end