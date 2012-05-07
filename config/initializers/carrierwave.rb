CarrierWave.configure do |config|
  
  config.root = Rails.root.join('tmp')
  config.cache_dir = 'carrierwave'
  
  config.s3_access_key_id = 's3-access-key'
  config.s3_secret_access_key = 's3-secret-key'
  config.s3_bucket = 'bucket'

end