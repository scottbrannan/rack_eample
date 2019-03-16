require 'net/https'
require 'json'

class GoogleMap
  def initialize(address)
    @address = address
  end

  def url
    URI::HTTPS.build({
      host: 'maps.googleapis.com',
      path: '/maps/api/staticmap',
      query: URI.encode_www_form({center: @address, size: '640x400', key: 'AIzaSyDCiptiR3S9QL6Ko1s7SqiWFGhmbYP0fcY'}),
    })
  end
end


module BasicAPI

  def api_key(value)
    @@api_key = value
  end

  def host(value)
    @@host = value
  end


  def endpoint(name, args, &block)
    define_method name do |query|
      url = URI::HTTPS.build({
        host: @@host,
        path: args[:path],
        query: URI.encode_www_form({q: query}),
      })

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      case args[:method]
      when 'GET'
        request = Net::HTTP::Get.new(url)
      when 'POST'
        request = Net::HTTP::Post.new(url)
      end

      request.basic_auth @@api_key, ''
      block.call(JSON.parse(http.request(request).read_body))

    end
  end
end

class Company
  attr_reader :json

  def initialize(json)
    @json = json
  end

  def name; @json['title']; end
  def address; @json['address_snippet']; end
end

class CompaniesHouseAPI

  extend BasicAPI

  api_key 'hyA4maSBnfeLaktGlTaqdaNt7GNkY3CVaQE3_-yd'
  host    'api.companieshouse.gov.uk'

  endpoint :company, method: 'GET', path: '/search/companies' do |response|
    Company.new(response['items'].first)
  end
end