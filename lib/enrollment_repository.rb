require 'csv'
require_relative 'enrollment'

class EnrollmentRepository
  attr_reader :enrollments
  def initialize
    @enrollments = {}
  end

  def load_data(file)
    generate_enrollment_repo(file)
  end

  def generate_enrollment_repo(paths)
    file = paths[:enrollment][:kindergarten]
    contents = CSV.read(file, headers: true, header_converters: :symbol)
    contents.each do |row|
      add_data_to_enrollment(row)        if !find_by_name(row[:location]).nil?
      assign_instance_of_enrollment(row) if find_by_name(row[:location]).nil?
    end
  end

  def assign_instance_of_enrollment(row)
      @enrollments[row[:location].upcase] =
      Enrollment.new({:name => row[:location], :kindergarten_participation =>
      { row[:timeframe].to_i => row[:data].to_f}})
  end

  def add_data_to_enrollment(row)
    name = row[:location].upcase
    er = enrollments[name]
    er.kindergarten_enrollment_percentage.merge!({row[:timeframe].to_i =>
    row[:data].to_f})
  end

  def find_by_name(name)
    enrollments[name.upcase]
  end
end
