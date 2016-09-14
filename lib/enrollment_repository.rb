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

  def generate_enrollment_repo(pathway)
    file = pathway[:enrollment][:kindergarten]
    contents = CSV.read(file, headers: true, header_converters: :symbol)
    contents.each do |row|
      
    end
  end

  def find_by_name(name)
    enrollments[name.upcase]
  end
end
