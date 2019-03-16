class CompaniesHouse
  
  def self.search(company_name)
    url = URI::HTTPS.build({
    host: 'api.companieshouse.gov.uk',
    path: '/search/companies',
    query: URI.encode_www_form({q: company_name}),
    })

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  
    request = Net::HTTP::Get.new(url)
    request["authorization"] = 'Basic aHlBNG1hU0JuZmVMYWt0R2xUYXFkYU50N0dOa1kzQ1ZhUUUzXy15ZDo='
    request["postman-token"] = '9365434a-a4fd-1438-db32-94704e52b7ca'
  
    response = http.request(request)
  
    JSON.parse(response.read_body)['items'].first['title']
  end
end