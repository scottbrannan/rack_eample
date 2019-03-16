class Company
  attr_reader :json

  def initialize(json)
    @json = json
  end

  def name; @json['title']; end
  def address; @json['address_snippet']; end
end