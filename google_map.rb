require 'net/https'

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