require "pry"
class District
  attr_reader :name, :district_repository
  def initialize(district_name, district_repository = nil)
    @name = district_name[:name].upcase
    @district_repository = district_repository
  end

  def enrollment
     @district_repository.find_enrollment_by_name(name)
  end
end
