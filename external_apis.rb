require 'net/https'
require 'json'
require 'csv'

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

class CompaniesHouseAPI

  extend BasicAPI

  api_key 'hyA4maSBnfeLaktGlTaqdaNt7GNkY3CVaQE3_-yd'
  host    'api.companieshouse.gov.uk'

  endpoint :company, method: 'GET', path: '/search/companies' do |response|
     csv_string  = CSV.generate do |csv|
       csv << ['Name','Address','Region']
       
      response['items'][0..10].collect {|company| [company['title'], company['address_snippet'], company['address']['region']]}.each do |item|
        puts item
        csv << item
      end
     end
  end
end