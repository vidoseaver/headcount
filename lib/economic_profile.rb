require_relative 'errors'
require_relative 'magic'
class EconomicProfile
  include Magic
  attr_reader :name,
              :median_household_income,
              :children_in_poverty,
              :free_or_reduced_price_lunch,
              :title_i

  def initialize(name,parent = "parent")
    if name.class == Hash
      pass_spec_harness(name)
    else
      @name                        = name
      @economic_profile_repository = parent
      @median_household_income     = Hash.new(Hash.new)
      @children_in_poverty         = Hash.new(Hash.new)
      @free_or_reduced_price_lunch = Hash.new(Hash.new)
      @title_i                     = Hash.new(Hash.new)
    end
  end

  def median_household_income_in_year(year)
    return raise UnknownDataError unless year_checker?(year)
    income = median_household_income.reduce([]) do |sum,((year_1,year_2),money)|
      sum << money if year.between?(year_1,year_2)
      sum
    end
    income.reduce(:+)/income.count
  end

  def year_checker?(year)
    median_household_income.keys.any? do |(first_year,last_year)|
      year.between?(first_year,last_year)
    end
  end

  def pass_spec_harness(data)
    @median_household_income     = data[:median_household_income]
    @children_in_poverty         = data[:children_in_poverty]
    @free_or_reduced_price_lunch = data[:free_or_reduced_price_lunch]
    @title_i                     = data[:title_i]
  end

  def median_household_income_average
    incomes = @median_household_income.values
    incomes.reduce(:+)/incomes.count
  end

  def children_in_poverty_in_year(year)
    return raise UnknownDataError unless children_in_poverty.keys.include?(year)
    children_in_poverty[year]
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    keys = free_or_reduced_price_lunch.keys
    return raise UnknownDataError unless keys.include?(year)
    free_or_reduced_price_lunch[year][:percentage]
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    keys = free_or_reduced_price_lunch.keys
    return raise UnknownDataError unless keys.include?(year)
    free_or_reduced_price_lunch[year][:total]
  end

  def title_i_in_year(year)
    keys = title_i.keys
    return raise UnknownDataError unless keys.include?(year)
    title_i[year]
  end

  def children_in_poverty_average
    return 0 if children_in_poverty.empty?
    added_percetages = @children_in_poverty.values.reduce(:+)
    long_total = added_percetages / @children_in_poverty.length
    wtm(long_total)
  end

  def free_or_reduced_price_lunch_average
    return  0 if free_or_reduced_price_lunch.empty?
    sum_percentage = free_or_reduced_price_lunch.values.reduce(0) do |sum, data|
      sum += data[:percentage]
    end
     wtm(sum_percentage / @free_or_reduced_price_lunch.length)
  end

  def average_median_household_income
    return  0 if median_household_income.empty?
    added_percetages = median_household_income.values.reduce(:+)
    added_percetages / median_household_income.length
  end
end
