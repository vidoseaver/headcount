require 'csv'
require_relative 'economic_profile'

class EconomicProfileRepository
attr_reader :economic_profiles

  def initialize
    @economic_profiles = Hash.new
    @num = 0
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

  def generate_economic_profiles(file_path)
    contents = CSV.read(file_path, headers: true, header_converters: :symbol)
    contents.each do |row|
      profile_generator(row) if find_by_name(row[:location]).nil?
      median_profile_maker(row, "median_household_income") if file_path.include?("Median")
      children_profile_maker(row, "children_in_poverty") if file_path.include?("poverty")
      title_profile_maker(row, "title_i") if file_path.include?("Title")
      lunch_profile_maker(row, "free_or_reduced_price_lunch") if file_path.include?("lunch")
      end
    end

    def profile_generator(row)
      return if find_by_name(row[:location]) != nil
      name = row[:location].upcase
      economic_profiles[name] = EconomicProfile.new(name, self)
    end

    def median_profile_maker(row, category)
      time = row[:timeframe].split("-").map {|num| num.to_i}
      profile = find_by_name(row[:location])
      if profile.send(category)[time].empty?
        profile.send(category).merge!({time => row[:data].to_f})
      else
        profile.send(category)[time].merge!({time => row[:data].to_f})
      end
    end

    def children_profile_maker(row, category)
      return unless row[:dataformat].downcase == "percent"
      time = row[:timeframe].to_i
      profile = find_by_name(row[:location])
      profile.send(category).merge!({time => row[:data].to_f})
    end

  def lunch_profile_maker(row, category)
    return unless row[:poverty_level] == "Eligible for Free or Reduced Lunch"
    profile = find_by_name(row[:location])
    timeframe  = row[:timeframe].to_i
    dataformat = row[:dataformat]
    data       = row[:data].to_f
    case
    when profile.send(category)[timeframe].empty? && row[:dataformat] == "Percent"
      profile.send(category)[timeframe] = {:percentage => data}
    when profile.send(category)[timeframe].empty? && row[:dataformat] == "Number"
      profile.send(category)[timeframe] = {:total => data}
    when  row[:dataformat] == "Percent"
      profile.send(category)[timeframe].merge!({:percentage => data})
    when  row[:dataformat] == "Number"
      profile.send(category)[timeframe].merge!({:total => data})
    end
  end

  def title_profile_maker(row, category)
    return unless row[:dataformat].downcase == "percent"
    time = row[:timeframe].to_i
    profile = find_by_name(row[:location])
    profile.send(category).merge!({time => row[:data].to_f})
  end


end
