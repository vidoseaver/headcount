require_relative 'magic'
class Enrollment
  include Magic
  attr_reader :kindergarten_enrollment_percentage,
              :name,
              :high_school_graduation

  def initialize(data)
    @name                               = data[:name].upcase
    @kindergarten_enrollment_percentage = data[:kindergarten_participation]
    @high_school_graduation             = Hash.new
  end

  def kindergarten_participation_by_year
     kindergarten_enrollment_percentage
  end

  def kindergarten_participation_in_year(year)
    return nil if kindergarten_enrollment_percentage[year].nil?
    wtm(kindergarten_enrollment_percentage[year])
  end

  def kindergarten_participation_rate_average
    added_percetages = @kindergarten_enrollment_percentage.values.reduce(:+)
    long_total = added_percetages / @kindergarten_enrollment_percentage.length
    wtm(long_total)
  end

  def graduation_rate_by_year
    truncated_rates = {}
    @high_school_graduation.each {|year, rate|truncated_rates[year] = wtm(rate)}
    truncated_rates
  end

  def graduation_rate_in_year(year)
    return nil if high_school_graduation[year].nil?
    wtm(high_school_graduation[year])
  end

  def high_school_graduation_rate_average
    added_percetages = @high_school_graduation.values.reduce(:+)
    long_total       = added_percetages / @high_school_graduation.length
    wtm(long_total)
  end
end
