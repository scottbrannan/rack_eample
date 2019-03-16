class ExampleRack
  def call(env)

    status  = 200
    headers = {}
    body    = ["Hello, world!\n"]

    [status, headers, body]
  end
end