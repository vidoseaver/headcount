require "pry"
require_relative "errors"

class StatewideTest
  attr_reader :name,
              :third_grade,
              :eighth_grade,
              :math,
              :reading,
              :writing,
              :state_wide_testing
  def initialize(name, parent_repository)
    @name = name.upcase
    @third_grade         = Hash.new(Hash.new)
    @eighth_grade        = Hash.new(Hash.new)
    @math                = Hash.new(Hash.new)
    @reading             = Hash.new(Hash.new)
    @writing             = Hash.new(Hash.new)
    @state_wide_testing  = parent_repository
  end

  def proficient_by_grade(grade)
    return third_grade  if grade == 3
    return eighth_grade if grade == 8
     raise UnknownDataError
  end

  def proficient_by_race_or_ethnicity(race)
    return raise UnknownDataError if math[race].nil?
    race = race.to_s.capitalize
    combined = math[race].keys.zip(math[race].values,reading[race].values,writing[race].values)
    combined.reduce({}) do |hash, (year,math,reading,writing)|
      hash[year] = {math: wtt(math.to_f), reading: wtt(reading.to_f), writing: wtt(writing.to_f)}
      hash
    end
  end

  def wtt(number)
    (number*1000).floor / 1000.0
  end
end
