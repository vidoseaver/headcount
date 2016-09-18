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
    return grade_to_numbers_and_symbols(third_grade) if grade == 3
    return grade_to_numbers_and_symbols(eighth_grade) if grade == 8
     raise UnknownDataError
  end

  def grade_to_numbers_and_symbols(grade)
    grade.reduce({}) do |hash, (year, data)|
      data = data.sort
      year = year.to_i
      data.each do |skill, level|
         hash[year] = { skill.to_sym.downcase => level.to_f} if hash[year].nil?
         hash[year].merge!({ skill.to_sym.downcase => wtt(level.to_f)})
       end
       hash
    end
  end

  def proficient_by_race_or_ethnicity(race)
    return raise UnknownDataError if math[race].nil?
    race = race.to_s.capitalize
    combined = math[race].keys.zip(math[race].values,reading[race].values,writing[race].values)
    combined.reduce({}) do |hash, (year,math,reading,writing)|
      hash[year.to_i] = {math: wtt(math.to_f), reading: wtt(reading.to_f), writing: wtt(writing.to_f)}
      hash
    end
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    return raise UnknownDataError if !value_checker?(subject,grade,year)
    grade == 3 ?  grade = third_grade : grade = eighth_grade
    number = wtt((grade[year.to_s][subject.to_s.capitalize]).to_f)
    number == 0.0 ? "N/A" : number
  end

  def value_checker?(subject,grade,year)
    return false unless grade == 3 || grade == 8
    return false unless subject == :math || subject == :reading || subject == :writing
    grade == 3 ?  grade = third_grade : grade = eighth_grade
    combined = grade.keys.zip(grade.values)
    combined.any? do |set|
      set.first == year.to_s && set.last.include?(subject.to_s.capitalize)
    end
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    return raise UnknownDataError if !value_checker_two?(subject,race,year)
    wtt((self.send(subject)[race.to_s.capitalize][year.to_s]).to_f)
  end

  def value_checker_two?(subject, race, year)
    return false unless subject == :math || subject == :reading || subject == :writing
    races = self.send(subject.to_s).keys
    return false unless races.include?(race.to_s.capitalize)
    years = self.send(subject.to_s)[race.to_s.capitalize].keys
    return false unless years.include?(year.to_s)
    true
  end

  def wtt(number)
    (number*1000).floor / 1000.0
  end

  # def top_statewide_test_year_over_year_growth(data)
  #   data[:grade] == 3 ? grade = third_grade : grade = eighth_grade
  #   binding.pry
  #   grade.values
  #
  # end
end
