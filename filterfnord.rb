class ProcessableImage

  @@tmp_file_path = '/tmp/'
  @@tmp_file_prefix = "filterfnord_"

  def initialize(base_file)
    @uuid = next_uuid
    create_working_file(base_file)
  end

  def process!    
    current_target_file
  end

private

  def cmd(bin, opts)

  end

  def create_working_file(file)    
    puts current_source_file
    puts current_target_file
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

  def next_uuid
    rand(36**16).to_s(36)
  end

end

class VintageProcessor < ProcessableImage

  def process!
    puts "yay"
    #cmd(:convert, :resize => "400x")
    super
  end

end



puts VintageProcessor.new('/home/paul/Code/filterfnord/test1.png').process!