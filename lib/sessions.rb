module Sessions
  def guess
    @request.session[:guess]
  end

  def guess=(value)
    @request.session[:guess] = value
  end

  def game
    @request.session[:game]
  end

  def game=(value)
    @request.session[:game] = value
  end

  def hint
    @request.session[:hint]
  end

  def hint=(value)
    @request.session[:hint] = value
  end
end
