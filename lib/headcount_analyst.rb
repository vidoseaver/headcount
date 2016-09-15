require "pry"

class HeadcountAnalyst
  def initialize(district_repo = district_repo)
    @district_repo = district_repo
  end

  def find_district_by_name(name)
    @district_repo.find_by_name(name)
  end

  def kindergarten_participation_rate_variation(district_one, district_two)
    first_enrollment = find_district_by_name(district_one).enrollment
    second_enrollment = find_district_by_name(district_two[:against]).enrollment
    first_enrollment_rate = first_enrollment.kindergarten_participation_rate_average
    second_enrollment_rate = second_enrollment.kindergarten_participation_rate_average
    rate = first_enrollment_rate / second_enrollment_rate
    rate.round(3)
  end

  def kindergarten_participation_rate_variation_trend(district_one, district_two)
    first_enrollment = find_district_by_name(district_one).enrollment
    second_enrollment = find_district_by_name(district_two[:against]).enrollment
    first_percentage = first_enrollment.kindergarten_enrollment_percentage
    second_percentage = second_enrollment.kindergarten_enrollment_percentage
    year_comparer(first_percentage,second_percentage)
  end

  def year_comparer(first_percentage,second_percentage)
    final = Hash.new
    first_percentage.each_with_index do |(key,value), index|
      final[key] = (value / second_percentage.values[index]).round(3)
    end
    final
  end
end
