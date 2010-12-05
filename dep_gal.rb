require 'rubygems'
require 'logger'
require 'rmagick'
load 'dep_gal_image.rb'
require 'yaml'

load 'dep_gal_helpers.rb'

module DepGal
  @@PHOTO_FILE_EXT = %W[jpg JPG png PNG jpeg JPEG]

  #@@CONFIG_VARS = ['filename_config', 'filenames_photos', 'dirname_source', 'dirname_project', 'dirname_project_photos' , 'dirname_root']
  
  def create_project(config, opt={})
    ragmag = DepGal::Project.new(config, opt)
  end
  
  
  class Project
    attr_accessor :config, :config_filename
    attr_accessor :image_list, :images, :image_list_file_h
    attr_accessor :is_built, :logger, :log_filename

    attr_accessor :image_versions

###### initialize methods

    def initialize(config_filename, opt={})
      @log_filename = opt[:log_filename].blank? ? 'project.log' : opt[:log_filename] 
      @log= Logger.new(STDOUT)
      @log.datetime_format = "%Y-%m-%d %H:%M:%S"
      
      @log.info('Project initializing')
      
      @options = opt
      
      if !File.exists?(config_filename)
        e = 'Config file doesn\'t exist!'
        @log.error e
        raise Exception, e
      else
        @config_filename = config_filename
        @config = init_config()
      end
    end
 
    def init_config
      @log.info("Initializing configuration")
      @config = init_yaml(@config_filename, {:validate_keys=>['directories', 'meta', ['directories','root_path']]})
      
      
      initial_dirs.each_pair{|k,v| 
        d = "#{k}: #{v}"
        if File.exists?(v)
          @log.info(d)
        else
          e = "#{d} doesn't exist!"
          @log.error(e)
          raise Exception, e
        end
      }
      @config
    end

## building methods    
    
    def build
      @log.info 'Building out'
      build_directories()
      build_image_list()
    end
    
    def build_directories
      @log.info("Building directories")
      build_dirs.each_pair do |k,v|
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
    
    def build_image_list
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
          rimage = DepGal::Image.new(fname)
          rimage.init_process
          a << rimage
        }
      end
      

      
    end
    
    

    
  ### output processes
  #
  
  def build_image_files(image)
  # image reads in DepGal::Image
  
    
  end  
    
    
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
        arr << image
      }
    }
    arr
  end



  def init_yaml(filename, opt = {})
    @log.info("Opening YAML: #{filename}")
    yaml = nil
    e = ''
    if filename.blank?
      e = "Can't leave filename blank"
    elsif !File.exists?(filename)
      e = "YAML #{filename} doesn't exist!"
    else
      yaml = YAML.load(File.open(filename))
      unless opt[:validate_keys].blank?
        invalid_keys = []
        opt[:validate_keys].each do |key|
          invalid_keys << key if yaml.dig(*key).blank?
        end
        e = "#{filename}: Keys #{invalid_keys.join(',')} are invalid" if invalid_keys.length > 0
      end
    end
    
    if !e.blank?
      @log.error(e)
      raise Exception, e
    else
      return yaml
    end  
  end



  #convenience methods
  
    def root_path
      File.expand_path(@config['directories']['root_path'])
    end
  
    def source_image_dir
      "#{root_path}/#{@config['directories']['source_image_dir']}"
    end

    def project_dir
      "#{root_path}/#{@config['directories']['project_dir']}"
    end
   
   def project_image_dir
     "#{project_dir}/images" 
   end
 
   def initial_dirs
     {'Root path'=>root_path, 'Source directory for images'=>source_image_dir}
   end
 
   def build_dirs
     {'Project directory'=>project_dir, 'Project images directory'=>project_image_dir}
   end
 
   def image_list_filename 
     "#{project_dir}/image_list.yml"
   end
   
   
   ### image attributes
   
   def image_viewer_width
     g = @config['gallery']['image_viewer_width']
     g.blank? ? @config['gallery']['width'] : g
   end

  end
  # end of class Project
end
