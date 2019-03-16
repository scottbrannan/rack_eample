require "webrick"

class MyServlet < WEBrick::HTTPServlet::AbstractServlet
  def do_GET (request, response)
    response.status = 404
    response.content_type = "text/plain"
    response.body = "Hello, world!"
  end
end

server = WEBrick::HTTPServer.new(:Port => 8080)

server.mount "/", MyServlet

trap("INT") {
    server.shutdown
}

server.start
