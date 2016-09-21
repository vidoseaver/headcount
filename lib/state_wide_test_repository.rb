require_relative 'statewide_test'
require "csv"
require 'pry'

class StatewideTestRepository
  attr_reader :state_wide_testings
  def initialize(district_repository = "default")
    @state_wide_testings = Hash.new
    @district_repository = district_repository
  end

  def load_data(path)
    populate_state_wide_testings(path) if  path.include?(:statewide_testing)
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
    return if find_by_name(row[:location]) != nil

    name = row[:location].upcase
    state_wide_testings[name] = StatewideTest.new(name, self)
  end

  def generate_state_wide_testings(path)
    contents = CSV.read(path, headers: true, header_converters: :symbol)
    contents.each do |row|
      state_wide_testing_maker(row) if find_by_name(row[:location]).nil?
      populate_state_wide_test_1(row, "third_grade") if path.include?("3rd")
      populate_state_wide_test_1(row, "eighth_grade") if path.include?("8th")
      populate_state_wide_test_2(row, "math") if path.include?("Math")
      populate_state_wide_test_2(row, "reading") if path.include?("Reading")
      populate_state_wide_test_2(row, "writing") if path.include?("Writing")
    end
  end

  def populate_state_wide_test_1(row, category)
    testing = find_by_name(row[:location])
    rowdata = row[:data].to_f
    if testing.send(category)[row[:timeframe]].empty?
      testing.send(category).merge!(row[:timeframe] => {row[:score] => rowdata})
    else
      testing.send(category)[(row[:timeframe])].merge!({row[:score] => rowdata})
    end
  end

  def populate_state_wide_test_2(row, category)
    testing  = find_by_name(row[:location])
    category = testing.send(category)
    if category[row[:race_ethnicity]].empty?
      category.merge!(row[:race_ethnicity] => {row[:timeframe] => row[:data]})
    else
      category[(row[:race_ethnicity])].merge!({row[:timeframe] => row[:data]})
    end
  end
end
