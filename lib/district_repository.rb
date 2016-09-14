require 'csv'
require_relative 'district'
require_relative 'enrollment_repository'


class DistrictRepository
  attr_reader :districts

  def initialize(districts = {})
    @districts = districts
    @enrollment_repository = EnrollmentRepository.new
  end


  def load_data(paths)
    generate_district_repo(paths)
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


  def find_by_name(name)
    districts[name]
  end

  def find_all_matching(fragment)
    districts.values.find_all do |district|
      district.name.include?(fragment.upcase)
    end
  end
end
