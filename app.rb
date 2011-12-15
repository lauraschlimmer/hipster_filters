$: << ::File.expand_path('../', __FILE__)

require "sinatra"
require "json"

require 'processable_image'
require 'lensflare_processor'
require 'blackwhite_processor'

PROCESSORS = {
  :lensflare => LensFlareProcessor,
  :blackwhite => BlackWhiteProcessor
}

allowed_files = {}

get "/" do
  File.open(::File.expand_path('../assets/index.html', __FILE__)).read
end


get "/get/:file" do
  if allowed_files.include?(params[:file])
  	File.open("/tmp/#{params[:file]}").read
  else
  	"not allowed"
  end
end


post '/process' do
  file_path = "/tmp/fnordfilter.upload.#{rand(36**16).to_s(36)}"
 
  File.open(file_path, 'wb') do |file|
    file.write(params[:file][:tempfile].read)
  end

  {}.tap do |ret|
    PROCESSORS.each do |k,p|
      out = p.new(file_path).process!.gsub('/tmp/', '')
      allowed_files[out] = true
      ret.merge!(k => out)
    end
  end.to_json
end