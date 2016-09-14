require 'pry'



class Enrollment
  attr_reader :kindergarten_enrollment_percentage, :name
  def initialize(new_hash)
    @name = new_hash[:name].upcase
    @kindergarten_enrollment_percentage = new_hash[:kindergarten_participation]
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
end
