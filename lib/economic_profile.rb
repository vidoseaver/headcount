require_relative 'errors'

class EconomicProfile
  attr_reader :name,
              :median_household_income,
              :children_in_poverty,
              :free_or_reduced_price_lunch,
              :title_i
  def initialize(name,parent = "parent")
    if name.class == Hash
      pass_spec_harness(name)
    else
      @name = name
      @economic_profile_repository = parent
      @median_household_income = Hash.new(Hash.new)
      @children_in_poverty = Hash.new(Hash.new)
      @free_or_reduced_price_lunch = Hash.new(Hash.new)
      @title_i = Hash.new(Hash.new)
    end
  end

  def median_household_income_in_year(year)
    return raise UnknownDataError unless year_checker?(year)

    incomes = @median_household_income.reduce([]) do |sum, ((first_year,last_year), income)|
      sum << income if year.between?(first_year,last_year)
      sum
    end
    incomes.reduce(:+)/incomes.count
  end

  def year_checker?(year)
    median_household_income.keys.any? do |(first_year,last_year)|
      year.between?(first_year,last_year)
    end
  end
  def pass_spec_harness(data)
    @median_household_income = data[:median_household_income]
    @children_in_poverty = data[:children_in_poverty]
    @free_or_reduced_price_lunch = data[:free_or_reduced_price_lunch]
    @title_i = data[:title_i]
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
end
