class PosterUploader < ImageUploader
  process resize_to_limit: [2048, 2048]
  process :optimize

  version :lg do
    process resize_to_fit: [1024, 2048]
    process optimize: [{ quality: 80 }]
  end

  version :md do
    process resize_to_fill: [512, 759]
    process optimize: [{ quality: 70 }]
  end

  version :sm do
    process resize_to_fill: [256, 379]
    process optimize: [{ quality: 60 }]
  end
end
