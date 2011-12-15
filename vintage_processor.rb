class VintageProcessor < ProcessableImage

  def process!
           
    # scale the white central light to our target size
    cmd_convert(
      asset_file('grad_center_light_1.png'), 
      helper_file(:gradcentl), 
      :resize => "#{width}x#{height}"
    )

    # multiply the white central light into our target image
    cmd_compose(
      "#{helper_file(:gradcentl)} #{current_source_file}",
      :compose => "over", 
      :gravity => "center"
    )

    incr_compositing_step

    # increase the target images saturation by 20%
    cmd_convert(
      :modulate => "100,120"
    )

    incr_compositing_step

    # increase the target images contrast by 20%
    cmd_convert(
      :"brightness-contrast" => "0x20"
    )

    incr_compositing_step

    # scale the vignette to our target size
    cmd_convert(
      asset_file('grad_vignette_1.png'), 
      helper_file(:gradvig), 
      :resize => "#{width}x#{height}!"
    )

    # multiply the vignette into our target image
    cmd_compose(
      "#{helper_file(:gradvig)} #{current_source_file}",
      :compose => "overlay", 
      :gravity => "center"
    )


    # done :)
    incr_compositing_step
    super

  end

end