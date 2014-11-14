Airbrake.configure do |config|
  config.api_key = '88d9a2da9c4fe4a90ceb0a5bf62c6a82'
  config.host    = 'poetic-errbit.herokuapp.com'
  config.port    = 80
  config.secure  = config.port == 443
end
