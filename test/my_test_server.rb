require 'webrick'


server = WEBrick::HTTPServer.new(:Port => 8080)


server.mount_proc '/' do |req, res| 
  req.method = "GET"

  res["Content-Type"] = "text/text" 
  res.body = "HTTPRequest#path"
  res.status = 200
end

  trap('INT') {server.shutdown}
  server.start
  