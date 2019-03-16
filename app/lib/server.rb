require "rack"
require 'webrick'
require 'uri'
require 'json'
require "html_dsl"
require "external_apis"

class DispatchServlet
  DISPATCH_TABLE = {}
  HTML_DSL = HtmlDsl.new

  attr_reader :path_prefix

  def initialize(path_prefix: '')
    @path_prefix = path_prefix.sub(/\A\/\z/,'')
  end

  def call(env)
    request  = Rack::Request.new(env)

    status   = 200
    headers  = {}
    body     = ''

    headers['Content-Type'] = "text/html"

    params = {
      html_dsl: HtmlDsl.new,
      path_prefix: path_prefix,
      service_provider: 'Orchard Information Systems',
      query: Rack::Utils.parse_nested_query(request.query_string),
    }

    if d = DISPATCH_TABLE[request.path.downcase.sub(path_prefix, '')]
      status = 200
      body   = d.call(params)
    else
      status = 404
      body   = 'Not Found'
    end

    [status, headers, Array(body)]
  end

  def self.get(path, &block)
    DISPATCH_TABLE[path] = block
  end

  def self.html(html_dsl: nil, &block)
    (html_dsl || HTML_DSL).document do
      html {
        instance_eval &block
      }
    end
  end
end
