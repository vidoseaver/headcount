require 'pry'
require 'csv'
require_relative 'district'
require_relative 'enrollment_repository'


class DistrictRepository
  attr_reader :districts
  def initialize
    @districts = Hash.new
    @enrollment_repository = EnrollmentRepository.new
  end


  def load_data(paths)
    generate_district_repo(paths)
  end

  def generate_district_repo(paths)
    file = paths[:enrollment][:kindergarten]
    contents = CSV.read(file, headers: true, header_converters: :symbol)
    contents.each do |row|
       verify_that_row_and_location_exist(row[:location])
    end
  end

  def verify_that_row_and_location_exist(district_name)
    districts[district_name.upcase] = District.new({name: district_name}) if districts != nil?
  end


  def find_by_name(name)
    districts[name.upcase]
  end

  def find_all_matching(fragment)
    districts.values.find_all do |district|
      district.name.include?(fragment.upcase)
    end
  end
end
