require './basic_api'

class CompaniesHouseAPI
  extend BasicAPI

  api_key 'hyA4maSBnfeLaktGlTaqdaNt7GNkY3CVaQE3_-yd'
  host    'api.companieshouse.gov.uk'

  endpoint :company, method: 'GET', path: '/search/companies' do |response|
    Company.new(response['items'].first)
  end
end