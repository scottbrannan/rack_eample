require 'server'

class CompanyInfoServer < DispatchServlet
  COMPANIES_HOUSE_API = CompaniesHouseAPI.new

  get '/' do |params|
    "Hello, #{params[:query]['name'] || 'World'}"
  end

  get '/test' do |params|
    "Test #{params[:path_prefix]}"
  end

  get  '/company-search' do |params|
    html {
      head {
        title "Company Search by #{params[:service_provider]}"
      }
      body {
        h1 "Company Search by #{params[:service_provider]}"

        form action: "#{params[:path_prefix]}/company-profile", method: 'GET' do
          input type: 'text', name: 'company'
          input type: 'submit'
        end
      }
    }
  end

  get '/company-profile' do |params|

    company = COMPANIES_HOUSE_API.company params[:query]['company']

    html {
      body {
        h1 company.name, class: 'foo'
        google_map 'some text', address: company.address
      }
    }
  end
end

# Rack::Handler::WEBrick.run(MyServlet.new, Port: 8080, Host: '0.0.0.0')
