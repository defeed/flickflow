if poster && poster.file
  json.is_primary poster.is_primary
  json.url_original poster.file_url
  json.url_small poster.file_url(:sm)
  json.url_medium poster.file_url(:md)
  json.url_large poster.file_url(:lg)
end
