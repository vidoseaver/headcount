class District
  attr_reader :name
  def initialize(district_name)
    @name = district_name[:name].upcase
  end
end
