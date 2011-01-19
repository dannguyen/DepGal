APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/config_depgal.yml")[RAILS_ENV]
IMAGE_STORAGE_PATH = "/system/images"
IMAGE_STYLES = APP_CONFIG['styles']