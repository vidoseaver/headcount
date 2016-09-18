class EconomicProfile
  attr_reader :name,
              :median_household_income,
              :children_in_poverty,
              :free_or_reduced_price_lunch,
              :title_i
  def initialize(name,parent)
    @name = name
    @economic_profile_repository = parent
    @median_household_income = Hash.new(Hash.new)
    @children_in_poverty = Hash.new(Hash.new)
    @free_or_reduced_price_lunch = Hash.new(Hash.new)
    @title_i = Hash.new(Hash.new)
  end

end
