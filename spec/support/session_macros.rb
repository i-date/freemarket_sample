module SessionMacros
  def add_session(arg)
    arg.each { |k, v| session[k] = v }
  end
end
