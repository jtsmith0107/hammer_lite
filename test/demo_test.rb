require 'webrick'
server =
      WEBrick::HTTPServer.new(:Port => 8000)
$counter = 0
server.mount_proc '/' do
      |req, res| if req.path == "/favicon.ico" $counter -= 1 elsif
      req.request_method == "GET"
       res.body = <<-HTML <html>
      <body> <p>Hey, welcome to Buck's cafsdafool
      website</p> <p>You are visitor number
      #{$counter}</p> <form method="POST" action="/">
      <label> Word to reverse! <input
      name="word_to_reverse"> </label> <input
      type="submit"> </form> </body> </html> HTML
      else res.body = <<-HTML <html> <body>
      <p>Hey, welcome to Buck's cafsdafool website</p>
      <p>You are visitor number #{$counter}</p>
      <p>Your word, REVERSED, is
      #{req.query["word_to_reverse"].reverse}</p> <form
      method="POST" action="/"> <label> Word to reverse!
      <input name="word_to_reverse"> </label> <input
      type="submit"> </form> </body> </html> HTML
      end res["Content-Type"] = "text/html" res.status = 200 $counter +=
      1
      end
trap 'INT' do
      server.shutdown
      end
server.start