class LensFlareProcessor < ProcessableImage

  def process!
    
    # scale the lensflare to our target width
    cmd_convert(
      asset_file('lensflare_1.png'), 
      helper_file(:lfscreen), 
      :resize => "#{width}x"
    )

    # screen the lensflare into our target image
    cmd_compose(
      "#{helper_file(:lfscreen)} #{current_source_file}",
      :compose => "screen", 
      :gravity => "northwest"
    )

    # done :)
    incr_compositing_step
    super

  end

end