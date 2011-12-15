class VintageProcessor < ProcessableImage

  def process!
    
    # scale the lensflare to our target width
    cmd_convert({})

    # done :)
    incr_compositing_step
    super

  end

end