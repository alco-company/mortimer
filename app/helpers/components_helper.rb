module ComponentsHelper
  def raw_t msg
    t(msg).html_safe
  end
end