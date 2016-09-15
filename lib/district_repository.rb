require 'csv'
require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'headcount_analyst'
require 'pry'


class DistrictRepository
  attr_reader :districts,
              :enrollment_repository,
              :headcount_analyst

  def initialize(districts = {})
    @districts = districts
    @enrollment_repository = EnrollmentRepository.new
    @headcount_analyst = HeadcountAnalyst.new(self)
  end


  def load_data(paths)
    generate_district_repo(paths)
    populate_kindergarten_enrollments(paths)
  end

  def generate_district_repo(paths)
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

  def populate_kindergarten_enrollments(path)
    @enrollment_repository.generate_enrollment_repo(path)
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
end
