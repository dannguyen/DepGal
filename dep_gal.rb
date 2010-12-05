require 'rubygems'
require 'logger'
require 'rmagick'
load 'dep_gal_convenience.rb'
load 'dep_gal_image.rb'
require 'yaml'

load 'dep_gal_helpers.rb'

module DepGal
  @@PHOTO_FILE_EXT = %W[jpg JPG png PNG jpeg JPEG]

  #@@CONFIG_VARS = ['filename_config', 'filenames_photos', 'dirname_source', 'dirname_project', 'dirname_project_photos' , 'dirname_root']
  
  def gogo(path='test_config.yml')
    p= DepGal::create_project('test_config.yml'); 
    p.build
    p.create_files
    p.finish
    p
  end
  
  def create_project(config, opt={})
    ragmag = DepGal::Project.new(config, opt)
  end
  
  
  class Project
    attr_accessor :config, :config_filename
    attr_accessor :image_list, :images, :image_list_file_h
    attr_accessor :is_built, :logger, :log_filename

    attr_accessor :standard_image_versions

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
      @config = init_yaml(@config_filename, {:validate_keys=>['directories', 'meta', ['directories','rootPath']]})
      
      
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
      
      # calculating standard_image_versions
      @standard_image_versions = {'thumbnail'=>{'width'=>thumbnail_width}, 'large'=>{'width'=>image_viewer_width}}
      
      @standard_image_versions.each_pair do |k,v|
        @log.info("Image versions: #{k} - #{v}")
      end
      
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
          rimage = DepGal::ImageEntry.new(fname)
          rimage.init_process
          a << rimage
        }
        
        write_image_list()
      end
      
    end
    
    
    
    ### create processes
    #
  
    def create_files
      @log.info("Create Files Phase")

      create_image_versions()
      
      
    end
  
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




  end
  # end of class Project
end
