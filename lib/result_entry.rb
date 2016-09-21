require 'pry'

class ResultEntry
  def initialize(data)
    @data = data
  end

  def free_and_reduced_price_lunch_rate
    @data[:free_and_reduced_price_lunch_rate]
  end

  def children_in_poverty_rate
    @data[:children_in_poverty_rate]
  end

  def high_school_graduation_rate
     @data[:high_school_graduation_rate]
  end

  def average_median_household_income
    @data[:average_median_household_income]
  end

  def kindergarten_variation
    @data[:kindergarten_variation]
  end

  def median_income_variation
    @data[:median_income_variation]
  end

  def name
    @data[:name]
  end
end
