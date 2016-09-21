require 'csv'
require_relative 'economic_profile'

class EconomicProfileRepository

  attr_reader :economic_profiles

  def initialize
    @economic_profiles = Hash.new
  end

  def load_data(paths)
    path_parser(paths)
  end

  def find_by_name(name)
    economic_profiles[name.upcase]
  end

  def path_parser(paths)
    paths = paths[:economic_profile].values
    paths.each do |file_path|
      generate_economic_profiles(file_path)
    end
  end

  def generate_economic_profiles(path)
    contents = CSV.read(path, headers: true, header_converters: :symbol)
    contents.each do |row|
      generator(row) if find_by_name(row[:location]).nil?
      median_maker(row,"median_household_income")     if path.include?("Median")
      children_maker(row, "children_in_poverty")      if path.include?("povert")
      title_maker(row, "title_i")                     if path.include?("Title")
      lunch_maker(row, "free_or_reduced_price_lunch") if path.include?("lunch")
    end
  end

  def generator(row)
    return if find_by_name(row[:location]) != nil
    name = row[:location].upcase
    economic_profiles[name] = EconomicProfile.new(name, self)
  end

  def median_maker(row, category)
    time    = row[:timeframe].split("-").map {|num| num.to_i}
    profile = find_by_name(row[:location])
    if profile.send(category)[time].empty?
      profile.send(category).merge!({time => row[:data].to_f})
    else
      profile.send(category)[time].merge!({time => row[:data].to_f})
    end
  end

  def children_maker(row, category)
    return unless row[:dataformat].downcase == "percent"
    time    = row[:timeframe].to_i
    profile = find_by_name(row[:location])
    profile.send(category).merge!({time => row[:data].to_f})
  end

  def lunch_maker(row, category)
    return unless row[:poverty_level] == "Eligible for Free or Reduced Lunch"
    profile    = find_by_name(row[:location])
    timeframe  = row[:timeframe].to_i
    data       = row[:data].to_f
    case
    when timeframe_is_empty_and_dataformat_is_percent?(row,category)
      profile.send(category)[timeframe] = {:percentage => data}
    when timeframe_is_empty_and_dataformat_is_number?(row,category)
      profile.send(category)[timeframe] = {:total => data}
    when  row[:dataformat] == "Percent"
      profile.send(category)[timeframe].merge!({:percentage => data})
    when  row[:dataformat] == "Number"
      profile.send(category)[timeframe].merge!({:total => data})
    end
  end

  def timeframe_is_empty_and_dataformat_is_percent?(row, category)
    profile    = find_by_name(row[:location])
    timeframe  = row[:timeframe].to_i
    profile.send(category)[timeframe].empty? && row[:dataformat] == "Percent"
  end

  def timeframe_is_empty_and_dataformat_is_number?(row, category)
    profile    = find_by_name(row[:location])
    timeframe  = row[:timeframe].to_i
    profile.send(category)[timeframe].empty? && row[:dataformat] == "Number"
  end

  def title_maker(row, category)
    return unless row[:dataformat].downcase == "percent"
    time    = row[:timeframe].to_i
    profile = find_by_name(row[:location])
    profile.send(category).merge!({time => row[:data].to_f})
  end
end
