APP_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/config_depgal.yml")[RAILS_ENV]
IMAGE_STORAGE_PATH = "/system/images"
IMAGE_STYLES = APP_CONFIG['styles']