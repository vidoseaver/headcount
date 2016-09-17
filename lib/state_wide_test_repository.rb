require_relative 'state_wide_test'
require "csv"
require 'pry'

class StateWideTestingRepository
  attr_reader :state_wide_testings
  def initialize(district_repository = "default")
    @state_wide_testings = Hash.new(0)
    @district_repository = district_repository
  end

  def load_data(path)
    populate_state_wide_testings(path)
  end

  def find_by_name(name)
    state_wide_testings[name.upcase]
  end

  def populate_state_wide_testings(paths)
    paths = paths[:statewide_testing].values
    paths.each do |path|
      generate_state_wide_testings(path)
    end
  end

  def state_wide_testing_maker(row)
    name = row[:location].upcase
    state_wide_testings[name] = StateWideTest.new(name, self)
  end

  def generate_state_wide_testings(path)
    contents = CSV.read(path, headers: true, header_converters: :symbol)
    contents.each do |row|
      state_wide_testing_maker(row) if !find_by_name(row[:location]).nil?
      populate_3rd_and_8th_grade(row, "third_grade") if path.include?("3rd grade")
      populate_3rd_and_8th_grade(row, "eighth_grade") if path.include?("8th grade")

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

  def populate_3rd_and_8th_grade(row, category)
    testing = find_by_name(row[:location])
    testing.send(category).merge!(row[:score] => {row[:timeframe] => row[:data]})
  
  end
end
