require "pry"
class District
  attr_reader :name
  def initialize(district_name, district_repository = nil)
    @name = district_name[:name].upcase
  end
end
