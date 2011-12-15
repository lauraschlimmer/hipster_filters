$: << ::File.expand_path('../', __FILE__)

require 'processable_image'
require 'lensflare_processor'
require 'blackwhite_processor'

res = LensFlareProcessor.new('/home/paul/Code/filterfnord/test1.png').process!
#res = BlackWhiteProcessor.new('/home/paul/Code/filterfnord/test1.png').process!
puts "DONE!: #{res}"
%x{gnome-open #{res} &> /dev/null}