require 'csv'
require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'headcount_analyst'
require_relative 'state_wide_test_repository'
require_relative 'economic_profile_repository'
require 'pry'


class DistrictRepository

  attr_reader :districts,
              :enrollment_repository,
              :headcount_analyst,
              :statewide_test_repository,
              :economic_profile_repository

  def initialize(districts = {})
    @districts = districts
    @headcount_analyst           = HeadcountAnalyst.new(self)
    @enrollment_repository       = EnrollmentRepository.new
    @statewide_test_repository   = StatewideTestRepository.new
    @economic_profile_repository = EconomicProfileRepository.new
  end


  def load_data(path)
    ep = :economic_profile
    st = :statewide_testing
    generate_district_repository(path)         if path.include?(:enrollment)
    populate_enrollment_repository(path)       if path.include?(:enrollment)
    populate_statewide_repository(path)        if path.include?(st)
    populate_economic_profile_repository(path) if path.include?(ep)
  end

  def generate_district_repository(paths)
    file = paths[:enrollment][:kindergarten]
    CSV.foreach(file, headers: true, header_converters: :symbol) do |row|
      name = row[:location].upcase
      data = {:name => name}
      check_for_objects = find_by_name(name)
      if check_for_objects == nil
        districts[name] = District.new(data, self)
      end
    end
  end

  def populate_enrollment_repository(path)
    @enrollment_repository.load_data(path)
  end

  def populate_statewide_repository(path)
    @statewide_test_repository.load_data(path)
  end

  def populate_economic_profile_repository(path)
    economic_profile_repository.load_data(path)
  end

  def find_by_name(name)
    districts[name.upcase]
  end

  def find_all_matching(fragment)
    districts.values.find_all do |district|
      district.name.include?(fragment.upcase)
    end
  end

  def find_enrollment_by_name(name)
    @enrollment_repository.find_by_name(name)
  end

  def find_statewide_test_by_name(name)
    @statewide_test_repository.find_by_name(name)
  end

  def find_economic_profile_by_name(name)
    @economic_profile_repository.find_by_name(name)
  end
end
