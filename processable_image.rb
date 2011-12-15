class ProcessableImage

  @@asset_path = ::File.expand_path('../assets', __FILE__)

  @@tmp_file_path = '/tmp/'
  @@tmp_file_prefix = "filterfnord_"
  @@bin_file_path = '/usr/bin/'
  

  def initialize(base_file)    
    @uuid = next_uuid
    create_working_file(base_file)
    parse_image_size
  end

  def process!        
    current_source_file
  end

private

  def cmd(bin, opts)
    "#{@@bin_file_path}#{bin} #{opts}".tap do |c|
      puts "executing: #{c}"
      system(c)      
    end
  end

  def create_working_file(base_file)    
    %x{cp #{base_file} #{current_source_file}}
  end

  def base_file
    [@@tmp_file_path, @@tmp_file_prefix, @uuid].join('')
  end

  def current_target_file
    current_file(next_compositing_step)
  end

  def current_source_file
    current_file(current_compositing_step)    
  end

  def current_file(compositing_step)
    [base_file, compositing_step, :png].join(".")
  end

  def helper_file(key)
    [base_file, key, :png].join(".")
  end

  def asset_file(filename)
    ::File.join(@@asset_path, filename)
  end

  def next_compositing_step
    current_compositing_step + 1
  end

  def current_compositing_step
    @current_compositiong_step ||= 0
  end

  def incr_compositing_step
    @current_compositiong_step += 1
  end

  def next_uuid
    rand(36**16).to_s(36)
  end

  def cmd_convert(in_file=nil, out_file=nil, opts)
    in_file ||= current_source_file
    out_file ||= current_target_file
    cmd(:convert, "#{in_file} #{opts_for_im(opts)} #{out_file}")
  end

  def cmd_compose(files, out_file=nil, opts)    
    out_file ||= current_target_file
    files = [files].flatten.join(" ")
    cmd(:composite, "#{opts_for_im(opts)} #{files} #{out_file}")
  end

  def opts_for_im(opts)
    opts.map{ |k,v| "-#{k} #{v}" }.join(" ")
  end

  def parse_image_size
    _cmd = %x{#{@@bin_file_path}identify #{current_source_file}}
    _cmd.match(/ ([0-9]+)x([0-9]+)\+0\+0 /).tap do |sstr|
      raise "FAIL-O-MATIC: file is not an image?" if sstr.nil?
      @width = sstr[1]; @height = sstr[2]
    end
  end

  def width
    @width
  end

  def height
    @height
  end

end
