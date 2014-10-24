class StillUploader < ImageUploader
  process resize_to_limit: [2048, 2048]
  process :optimize
  
  version :lg do
    process resize_to_fit: [1024, 1024]
    process optimize: [{quality: 75}]
  end
  
  version :md do
    process resize_to_fit: [512, 512]
    process optimize: [{quality: 60}]
  end
end
