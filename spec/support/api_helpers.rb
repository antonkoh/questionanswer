module ApiHelpers
  def do_request(method, url, options = {})
    send method, url, {format: :json}.merge(options)
  end
end