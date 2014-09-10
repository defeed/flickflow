# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  include CarrierWave::ImageOptimizer
  
  def self.set_storage
    Rails.env.production? ? :fog : :file
  end
  
  def store_dir_prefix
    Rails.env.production? ? nil : 'uploads/'
  end
  
  # Assign storage dynamically
  storage set_storage

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "#{store_dir_prefix}#{model.class.to_s.underscore}/#{model.imageable.uuid}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  # 
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "#{model.uuid}.#{file.extension}" if original_filename
  end
end
