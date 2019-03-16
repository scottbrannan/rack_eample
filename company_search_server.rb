require './rack_server'

class CompanySearchServer < RackServer
  COMPANIES_HOUSE_API = CompaniesHouseAPI.new

  get '/company-profile' do |params|

    company_csv = COMPANIES_HOUSE_API.company params[:query]['company']
    
    company_csv

  end
end

Rack::Handler::WEBrick.run(CompanySearchServer.new, Port: 8080, Host: '0.0.0.0')
