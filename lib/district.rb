require "pry"
class District

  attr_reader :name,
              :district_repository

  def initialize(district_name, district_repository = nil)
    @name = district_name[:name].upcase
    @district_repository = district_repository
  end

  def enrollment
     @district_repository.find_enrollment_by_name(name)
  end

  def statewide_test
     @district_repository.find_statewide_test_by_name(name)
  end

  def economic_profile
    @district_repository.find_economic_profile_by_name(name)
  end
end
