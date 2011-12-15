class BlackWhiteProcessor < ProcessableImage

  def process!
    
    # make the target image black and white
    cmd_convert(
      :type => "grayscale"
    )

    incr_compositing_step

    # scale the gradient to our target size
    cmd_convert(
      asset_file('bwgrad_1.png'), 
      helper_file(:bwgrad), 
      :resize => "#{width}x#{height}!"
    )

    # multiply the gradient into our target image
    cmd_compose(
      "#{helper_file(:bwgrad)} #{current_source_file}",
      :compose => "softlight", 
      :gravity => "center"
    )

    # done :)
    incr_compositing_step
    super

  end

end
