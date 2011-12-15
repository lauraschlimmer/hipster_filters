$: << ::File.expand_path('../', __FILE__)

require "sinatra"
require "json"

require 'processable_image'
require 'lensflare_processor'
require 'blackwhite_processor'
require 'vintage_processor'

PROCESSORS = {
  :vintage => VintageProcessor,
  :blackwhite => BlackWhiteProcessor,
  :lensflare => LensFlareProcessor
}

$allowed_files = {}

get "/" do
  File.open(::File.expand_path('../assets/index.html', __FILE__)).read
end


get "/get/:file" do
  if $allowed_files.include?(params[:file])
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

  orig_file = file_path.gsub('/tmp/', '')
  allow_file(orig_file)

  { :original => orig_file }.tap do |ret|
    PROCESSORS.each do |k,p|
      out = p.new(file_path).process!.gsub('/tmp/', '')
      allow_file(out)
      ret.merge!(k => out)
    end
  end.to_json
end

def allow_file(f) 
  $allowed_files[f] = true
end