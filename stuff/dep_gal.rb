require 'rubygems'
require 'logger'

load 'lib/dep_gal_convenience.rb'
load 'lib/dep_gal_image.rb'
load 'lib/dep_gal_template.rb'

load 'lib/project/dep_gal_configure.rb'
load 'lib/project/dep_gal_construct.rb'
load 'lib/project/dep_gal_frame.rb'
load 'lib/project/dep_gal_showcase.rb'


load 'lib/dep_gal_helpers.rb'

module DepGal
  @@PHOTO_FILE_EXT = %W[jpg JPG png PNG jpeg JPEG]

  #@@CONFIG_VARS = ['filename_config', 'filenames_photos', 'dirname_source', 'dirname_project', 'dirname_project_photos' , 'dirname_root']
  
  def gogo(path='test_config.yml')
    p= DepGal::create_project('test_config.yml'); 
    p.configure
    p.construct
    p.frame
    p.showcase
    p.finish
    p
  end
  
  def create_project(config, opt={})
    DepGal::Project.new(config, opt)
  end
  
  
  class Project
    attr_accessor :config, :config_filename
    attr_accessor :image_list, :images, :image_list_file_h
    attr_accessor :pages, :homepage
    attr_accessor :is_built, :logger, :log_filename

    attr_accessor :standard_image_versions

###### initialize methods

    @@default_options = {}

    def initialize(config_filename, opt={})
      @log_filename = opt[:log_filename].blank? ? 'project.log' : opt[:log_filename] 
      @log= Logger.new(STDOUT)
      @log.datetime_format = "%Y-%m-%d %H:%M:%S"
      
      @log.info('Project initializing')
      @config_filename=config_filename
      @options = opt
     
    end
 
    def configure
      @log.info 'Configuring'
      if !File.exists?(@config_filename) 
        raise Exception, "Config file #{@config_filename} doesn\'t exist!"
      else
        @config = read_config()
      end
    end
    
    
    def construct
      @log.info 'Constructing filesystem'
      construct_directories()
      construct_image_list()
    end
    

    def frame
      @log.info 'Framing pictures'
      create_image_versions()      
    end
    
    def showcase
      @log.info "Building out templates"
      @pages = make_pages
    end
## building methods    
    
    
    ### create processes
    #
  
    
    ########
  
    def finish
      @log.info("Finishing and closing project")
      write_image_list
    end
  
    #########
    def write_image_list
      @log.info("Writing images to #{image_list_filename}")
      image_list_file_h = File.open(image_list_filename, 'w')
    
      @images.each do |rimage|
        YAML.dump(rimage, image_list_file_h)
      end
      image_list_file_h.close
    end
  
    def load_image_list
      @log.info("Loading images from #{image_list_filename}")
      arr = []
      File.open(image_list_filename){|file|
        YAML.load_documents(file){|image|
          puts image.source_filename
          image.build
          arr << image
        }
      }
      arr
    end



    




  end
  # end of class Project
end
