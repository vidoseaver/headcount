require "pry"
require_relative 'magic'
require_relative 'result_set'
require_relative 'result_entry'


class HeadcountAnalyst
  include Magic

  def initialize(district_repo = "district_repo")
    @district_repo = district_repo
  end

  def find_district_by_name(name)
    @district_repo.find_by_name(name)
  end

  def kindergarten_participation_rate_variation(district_one, district_two)
    first_enrollment  = find_district_by_name(district_one).enrollment
    second_enrollment = find_district_by_name(district_two[:against]).enrollment
    first_rate        = first_enrollment.kindergarten_participation_rate_average
    second_rate = second_enrollment.kindergarten_participation_rate_average
    rate = first_rate / second_rate
    rate.round(3)
  end

  def kindergarten_participation_rate_variation_trend(district_one,district_two)
    first_enrollment  = find_district_by_name(district_one).enrollment
    second_enrollment = find_district_by_name(district_two[:against]).enrollment
    first_percentage  = first_enrollment.kindergarten_enrollment_percentage
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
    first_enrollment  = find_district_by_name(district_one).enrollment
    second_enrollment = find_district_by_name(district_two[:against]).enrollment
    first_rate        = first_enrollment.high_school_graduation_rate_average
    second_rate       = second_enrollment.high_school_graduation_rate_average
    rate = first_rate / second_rate
    rate.round(3)
  end

  def kindergarten_participation_against_high_school_graduation(name)
    graduation_variant  = high_school_rate_variation(name,:against =>"COLORADO")
    kindergarten_variation  =
    kindergarten_participation_rate_variation(name, :against => "COLORADO")
    return 0 if kindergarten_variation / graduation_variant == 0
    kindergarten_variation / graduation_variant
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
    certain_district_checker("variation_correlation",name) if name.class== Array
  end

  def certain_district_checker(method, district_names)
    districts   = district_names.map {|name| find_district_by_name(name)}
    truths      = districts.map do |district|
    self.send(method, district.name)
    end
    above_seventy?(truths.count(true)/truths.count.to_f)
  end

  def all_district_checker(method)
    districts = @district_repo.districts.values
    truths    = districts.map do |district|
    self.send(method,district.name)
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

  def average_highschool_graduation_rate
    districts = @district_repo.districts.values
    combined  = districts.reduce(0) do |sum, district|
      sum += district.enrollment.high_school_graduation_rate_average
    end
    wtm(combined/districts.count)
  end

  def average_children_in_poverty_rate
    districts = @district_repo.districts.values
    combined  = districts.reduce(0) do |sum, district|
      value   = district.economic_profile.children_in_poverty_average
      sum += value unless value.nil?
      sum
    end
    wtm(combined/districts.count)
  end

  def free_and_reduced_price_lunch_rate
    districts = @district_repo.districts.values
    combined  = districts.reduce(0) do |sum, district|
      value   = district.economic_profile.free_or_reduced_price_lunch_average
      sum += value unless value.nil?
      sum
    end
    wtm(combined/districts.count)
  end

  def statewide_average_result_entry_for_graduation_and_poverty
    data =
    {name:"statewide_average",
    free_and_reduced_price_lunch_rate: free_and_reduced_price_lunch_rate,
    children_in_poverty_rate:          average_children_in_poverty_rate,
    high_school_graduation_rate:       average_highschool_graduation_rate}
    result_entry_maker(data)
  end

  def result_entry_maker(data)
    ResultEntry.new(data)
  end

  def high_poverty_and_high_school_graduation_result_entries
    @district_repo.districts.values.map do |district|
      dep = district.economic_profile
      de = district.enrollment
      data =
      {name:district.name,
      free_and_reduced_price_lunch_rate:dep.free_or_reduced_price_lunch_average,
      children_in_poverty_rate:         dep.children_in_poverty_average,
      high_school_graduation_rate:      de.high_school_graduation_rate_average}
      result_entry_maker(data)
    end
  end

  def all_districts_with_high_poverty_and_graduation_rate
    average = statewide_average_result_entry_for_graduation_and_poverty
    ave_forlr = average.free_and_reduced_price_lunch_rate
    ave_cip = average.children_in_poverty_rate
    ave_hgr = average.high_school_graduation_rate
    all_result_entries = high_poverty_and_high_school_graduation_result_entries
    all_result_entries.select do |result_entry|
      ((result_entry.free_and_reduced_price_lunch_rate > ave_forlr) &&
      (result_entry.children_in_poverty_rate          > ave_cip) &&
      (result_entry.high_school_graduation_rate       > ave_hgr))
    end
  end

  def result_set_maker(matching_districts_and_statewide_average)
    ResultSet.new(matching_districts_and_statewide_average)
  end

  def high_poverty_and_high_school_graduation
    matching_districts = all_districts_with_high_poverty_and_graduation_rate
    statewide_average  =
    statewide_average_result_entry_for_graduation_and_poverty
    matching_districts_and_statewide_average =
    {matching_districts:  matching_districts,
      statewide_average:    statewide_average}
    result_set_maker(matching_districts_and_statewide_average)
  end

  def statewide_average_median_house_hold_income
    colorado = find_district_by_name("COLORADO")
    colorado.economic_profile.average_median_household_income
  end

  def statewide_average_result_entry_for_mhi_and_poverty
    data =
    {name:"statewide_average",
    average_median_household_income: statewide_average_median_house_hold_income,
    children_in_poverty_rate:        average_children_in_poverty_rate,
    }
    result_entry_maker(data)
  end

  def high_poverty_and_high_median_income_result_entries
    @district_repo.districts.values.map do |district|
      dep = district.economic_profile
      data =
      {name:district.name,
      children_in_poverty_rate:          dep.children_in_poverty_average,
      average_median_household_income:   dep.average_median_household_income}
      result_entry_maker(data)
    end
  end

  def all_districts_with_high_cip_and_ami
    average    = statewide_average_result_entry_for_mhi_and_poverty
    ave_cip    = average.children_in_poverty_rate
    ave_samhdi = average.average_median_household_income
    all_result_entries = high_poverty_and_high_median_income_result_entries
    all_result_entries.select do |result_entry|
      ((result_entry.children_in_poverty_rate        > ave_cip) &&
      (result_entry.average_median_household_income  > ave_samhdi))
    end
  end

  def high_income_disparity
    matching_districts = all_districts_with_high_cip_and_ami
    statewide_average  = statewide_average_result_entry_for_mhi_and_poverty
    matching_districts_and_statewide_average =
    {matching_districts:  matching_districts,
      statewide_average:    statewide_average}
    result_set_maker(matching_districts_and_statewide_average)
  end

  def median_income_variation(district_one, district_two)
    first       = find_district_by_name(district_one).economic_profile
    second      = find_district_by_name(district_two[:against]).economic_profile
    first_rate  = first.average_median_household_income
    second_rate = second.average_median_household_income
    rate        = first_rate / second_rate
    rate.round(3)
  end

  def kindergarten_participation_against_household_income(district_name)
    district_name    = district_name.upcase
    colorado         = {against:"COLORADO"}
    income_variation = median_income_variation(district_name,colorado)
    kindergarten_variation =
    kindergarten_participation_rate_variation(district_name,colorado)
    return 0 if income_variation == 0
    total = kindergarten_variation/income_variation
    total.round(3)
  end

  def kindergarten_participation_correlates_with_household_income(name)
    name.keys.first == :for ? name = name[:for] : name = name[:across]
    return income_correlates_with_kindergarten(name) if name == "STATEWIDE"
    return income_correlates_with_kindergarten(name) if name.class == Array
    rate = kindergarten_participation_against_household_income(name)
    rate.between?(0.6,1.5)
  end

  def income_correlates_with_kindergarten(name)
    name.class == Array ? names = name : names = @district_repo.districts.keys
    trues  = names.reduce([]) do |sum, name|
      name = {for:name}
      sum << kindergarten_participation_correlates_with_household_income(name)
    end
    above_seventy?(trues.count(true)/trues.count)
  end
end
