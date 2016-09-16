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
    first_rate = first_enrollment.kindergarten_participation_rate_average
    second_rate = second_enrollment.kindergarten_participation_rate_average
    rate = first_rate / second_rate
    rate.round(3)
  end

  def kindergarten_participation_rate_variation_trend(district_one,district_two)
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

  def high_school_rate_variation(district_one, district_two)
    first_enrollment = find_district_by_name(district_one).enrollment
    second_enrollment = find_district_by_name(district_two[:against]).enrollment
    first_rate = first_enrollment.high_school_graduation_rate_average
    second_rate = second_enrollment.high_school_graduation_rate_average
    rate = first_rate / second_rate
    rate.round(3)
  end

  def kindergarten_participation_against_high_school_graduation(name)
    first_enrollment = find_district_by_name(name).enrollment
    second_enrollment = find_district_by_name("COLORADO").enrollment
    graduation_variation =high_school_rate_variation(name,:against =>"COLORADO")
    kind_variation =
    kindergarten_participation_rate_variation(name, :against => "COLORADO")
    return 0 if kind_variation/graduation_variation == 0
    kind_variation/graduation_variation
  end

  def correlates?(number)
    number = number.to_s
    number.to_f.between?(0.6, 1.5)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(name)
    name.keys.first == :for ? name = name[:for] : name = name[:across]
    districts = @district_repo.districts.keys
    return all_district_checker("variation_correlation") if name == "STATEWIDE"
    return variation_correlation(name) if districts.include?(name)
    certain_district_checker("variation_correlation",name) if name.class==Array
  end

  def certain_district_checker(method, district_names)
    districts = district_names.map {|name| find_district_by_name(name)}
    truths = districts.map do |district|
      variation = self.send(method, district.name)
    end
    above_seventy?(truths.count(true)/truths.count.to_f)
  end

  def all_district_checker(method)
    districts = @district_repo.districts.values
    truths = districts.map do |district|
    variation = self.send(method,district.name)
    end
    above_seventy?(truths.count(true)/truths.count.to_f)
  end

  def above_seventy?(number)
    number.to_f.between?(0.7, 1.0)
  end

  def variation_correlation(name)
    variation = kindergarten_participation_against_high_school_graduation(name)
    correlates?(variation)
  end
end
