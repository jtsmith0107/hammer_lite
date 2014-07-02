require 'json'
require 'webrick'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    @cookies = Hash.new
    # p req.cookies.first.name
    #array of Cookies, which are form value = {}
    req.cookies.each do |cookie|
      if cookie.name == "_rails_lite_app"
        cookie_value = JSON.parse(cookie.value)
        @cookies.merge!(cookie_value)
      end
    end
  end

  def [](key)
    @cookies[key]
  end

  def []=(key, val)
    @cookies[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    name = '_rails_lite_app'
    value = @cookies.to_json
    new_cookies = WEBrick::Cookie.new(name, value)
    res.cookies.push(new_cookies)
  end
end
