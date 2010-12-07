require 'rubygems'
require 'rmagick'
require 'rag_image.rb'
require 'yaml'
#require 'state_machine'

load 'dep_gal_helpers.rb'

module DepGal
  @@PHOTO_FILE_EXT= %W[jpg JPG png PNG jpeg JPEG]
  @@CONFIG_VARS = ['filename_config', 'filenames_photos', 'dirname_source', 'dirname_project', 'dirname_project_photos' , 'dirname_root']
  
  def create_project(source_dir='photos', new_dir='rag_projects/test')
    ragmag = DepGal::Project.new(new_dir, {:source_dir=>source_dir})
  end
  
  class Project
    attr_accessor :config
    #attr_accessor :dirname_source, :dirname_project, :dirname_project_photos, :filename_config, :filenames_photos, 
    attr_accessor :created



###### initialize methods

    def initialize(project_dir, opt={})
      @config ={}
      if File.exists?("#{project_dir}/config.yml")
        @created=reopen(project_dir)
      else
        unless(!opt[:source_dir].blank? && File.exists?(opt[:source_dir]))
          raise Exception, "Source directory doesn't exist"
        else
          init_files(opt[:source_dir], project_dir)
        end
      end
    end

    def init_files(source_dirname, project_dirname)
      puts "Init files"
      
      @config['dirname_project'] = File.expand_path(project_dirname) 
        fuf_maked_dirs(@config['dirname_project'])
      @config['dirname_source'] = File.expand_path(source_dirname)

      @config['dirname_project_photos'] =  "#{self.project_dir}/photos"
      
      Dir.mkdir( self.project_photo_dir )

      @config['filename_config'] = "#{self.project_dir}/config.yml"
      
      @config['photos'] = []
      fuf_glob_all_set(@config['dirname_source'], @@PHOTO_FILE_EXT).each do |f|
          
          rimg =  DepGal::Image.new(f, 
          File.dirname(f).gsub("#{self.source_dir}/", ''),
          self.project_photo_dir.gsub("#{self.source_dir}/", ''))
          
          rimg.build
          
          @config['photos'] << rimg
          
      end
      
      write_config
      @created = true
    end

    def reopen(dirproj)
      @config['dirname_project'] = dirproj
      @config['filename_config'] = "#{dirproj}/config.yml"
      read_config()
      puts "Reopened project"
      return true
    end
    
    def read_config
      @config = YAML.load(File.open(@config['filename_config'])).config
      
    end
    
   def write_config(yaml=nil, opt={})
      puts "In write_config"
      if(yaml.blank?)
        puts "Yaml was blank, writing to #{@config['filename_config']}"
        ystr = YAML.dump(self.config)
        file = File.new("#{@config['filename_config']}", 'w')
        file.write(ystr)
        file.close
      end
    end

    ########################################################################
    # image handling
    
    def initialize_rag_images
      @rag_images = @config['filenames_photos'].map{|f| RagImage.new(f['original_path'], f['project_path'] ) }
    end

    ########################################################################
    #convenience methods
  def project_dir
    @config['dirname_project'] 
  end
  def project_photo_dir
    @config['dirname_project_photos'] 
  end
       
   def source_dir
     @config['dirname_source']   
   end

    def number_of_photos
      @config['filenames_photos'].length
    end
    
    def project_created?
      @created
    end
  end
  # end of class Project


  class Image #not to be confused with class RagImage
    attr_accessor :base_filename, :base_subdir
    attr_accessor :source_path, :export_path
    attr_accessor :versions
    attr_accessor :rag_image
    
    def initialize(s_name, sub_dir, x_path)
      @base_filename = File.basename(s_name)
      @base_subdir = "#{sub_dir}/"
      @source_path = File.dirname(s_name)
      @export_path = x_path
      @versions = ['original']
    end
    
    def init_process
      @rag_image=RagImage.new(self.original_filename)
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
#end of module
    
    
=begin    
    state_machine :state, :initial=>:activated do      
      
      before_transition any => any do |project, transition|
        puts "Attempting #{transition}"
      end  
        
      event :activate do
        transition :activated => :opened if :project_created?
        transition :activated => :created
      end
      
      event :create_project do
        transition :created=>:opened
      end
      
      event :close_project do
        transition :opened => :closed
      end
    
    
    
      state :activated do
        puts "in state activated state"
      end  
      
      state :created do
        puts "in state created"
      end
      
      state :opened do
        puts "in state opened"
      end
      
      state :closed do
        puts "closed"
      end
      
    end
    
    # end of state_machine
    
    def initialize
      super()
    end
  
  end
  # end of project state machine inits
=end
