


class Enrollment
  attr_reader :kindergarten_enrollment_percentage,
              :name,
              :high_school_graduation
  def initialize(data)
    @name = data[:name].upcase
    @kindergarten_enrollment_percentage = data[:kindergarten_participation]
    @high_school_graduation = Hash.new
  end

  def kindergarten_participation_by_year
     kindergarten_enrollment_percentage
  end

  def kindergarten_participation_in_year(year)
    return nil if kindergarten_enrollment_percentage[year].nil?
    wtt(kindergarten_enrollment_percentage[year])
  end

  def wtt(number)
    (number*1000).floor / 1000.0
  end

  def kindergarten_participation_rate_average
    added_percetages = @kindergarten_enrollment_percentage.values.reduce(:+)
    long_total = added_percetages / @kindergarten_enrollment_percentage.length
    wtt(long_total)
  end

  #starting highschool stuff
  def graduation_rate_by_year
    truncated_rates = {}
    @high_school_graduation.each {|year, rate|truncated_rates[year] = wtt(rate)}
    truncated_rates
  end

  def graduation_rate_in_year(year)
    return nil if high_school_graduation[year].nil?
    wtt(high_school_graduation[year])
  end

  def high_school_graduation_rate_average
    added_percetages = @high_school_graduation.values.reduce(:+)
    long_total = added_percetages / @high_school_graduation.length
    wtt(long_total)
  end
end
