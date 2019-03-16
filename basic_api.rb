require 'json'
require 'net/https'

module BasicAPI

  def api_key(value)
    @api_key = value
  end

  def host(value)
    @host = value
  end


  def endpoint(name, args, &block)
    define_method name do |query|
      puts ">>> #{@host}"
      url = URI::HTTPS.build({
        host: @host,
        path: args[:path],
        query: URI.encode_www_form({q: query}),
      })

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(url)
      request["authorization"] = 'Basic aHlBNG1hU0JuZmVMYWt0R2xUYXFkYU50N0dOa1kzQ1ZhUUUzXy15ZDo='
      JSON.parse(http.request(request).read_body)
    end
  end
end