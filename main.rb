ENV["RACK_ENV"] ||= "development"
Bundler.require(:default, ENV["RACK_ENV"])
