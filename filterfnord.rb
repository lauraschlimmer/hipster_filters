class ProcessableImage

  @@tmp_file_path = '/tmp/'
  @@tmp_file_prefix = "filterfnord_"
  @@bin_file_path = '/usr/bin/'

  def initialize(base_file)
    @uuid = next_uuid
    create_working_file(base_file)
  end

  def process!    
    current_source_file
  end

private

  def cmd(bin, opts)
    "#{@@bin_file_path}#{bin} #{opts}".tap do |c|
      puts "executing: #{c}"
      system(c)
      incr_compositing_step
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

  def cmd_convert(opts)
    cmd(:convert, "#{current_source_file} #{opts_for_im(opts)} #{current_target_file}")
  end

  def opts_for_im(opts)
    opts.map{ |k,v| "-#{k} #{v}" }.join(" ")
  end

end


class VintageProcessor < ProcessableImage

  def process!
    
    # testin'
    cmd_convert(:resize => "400x")

    super

  end

end



res = VintageProcessor.new('/home/paul/Code/filterfnord/test1.png').process!
puts "DONE!: #{res}"
%x{gnome-open #{res} &> /dev/null}