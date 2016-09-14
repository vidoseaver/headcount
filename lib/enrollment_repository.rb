require 'pry'
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
      assign_instance_of_enrollment(row)
    end
  end
    def assign_instance_of_enrollment(row)
      if !find_by_name(row[:location])
        @enrollments[row[:location].upcase] = Enrollment.new({:name => row[:location], :kindergarten_participation => { row[:timeframe].to_i => row[:data].to_f}})
      else
      end
    end

    def add_data_to_enrollment(row)
      enrollment = @enrollments[row[:location].upcase]
      if enrollment[]({:name => row[:location], :kindergarten_participation => { row[:timeframe].to_i => row[:data].to_f}})



  def find_by_name(name)
    enrollments[name.upcase]
  end
end
