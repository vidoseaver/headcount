require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require './lib/headcount_analyst'
require 'pry'


class HeadcountAnalystTest < Minitest::Test

  def setup
    @district_repo = DistrictRepository.new
    @district_repo.load_data({enrollment: {kindergarten: "./data/Kindergartners in full-day program.csv"}})
    @headcount_analyst = @district_repo.headcount_analyst

  end

  def test_head_count_is_a_class
    headcount = HeadcountAnalyst.new

    assert_equal HeadcountAnalyst, headcount.class
  end

  def test_can_find_district_by_name
    assert_instance_of District, @headcount_analyst.find_district_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", @headcount_analyst.find_district_by_name("academy 20").name
  end

  def test_compare_district_kindergarten_participation_rate_average_vs_all_of_colorado
    assert_equal 0.766, @headcount_analyst.kindergarten_participation_rate_variation("academy 20", :against => "COLORADO")
  end

  def test_compare_district_kindergarten_participation_rate_average_vs_another_district
    assert_equal 0.447, @headcount_analyst.kindergarten_participation_rate_variation("academy 20", :against => "yuma school district 1")
  end

  def test_compare_district_kindergarten_participation_rate_variation_trend_per_year
    expected = {2007=>0.992, 2006=>1.05, 2005=>0.961, 2004=>1.258, 2008=>0.718, 2009=>0.652, 2010=>0.681, 2011=>0.728, 2012=>0.689, 2013=>0.694, 2014=>0.661}

    assert_equal expected , @headcount_analyst.kindergarten_participation_rate_variation_trend("academy 20", :against => "COLORADO")
  end

  def test_year_comparer
    data_set_one = {2007=>0.39159, 2006=>0.35364, 2005=>0.26709, 2004=>0.30201, 2008=>0.38456, 2009=>0.39, 2010=>0.43628, 2011=>0.489, 2012=>0.47883, 2013=>0.48774, 2014=>0.49022}
    data_set_two = {2007=>0.39465, 2006=>0.33677, 2005=>0.27807, 2004=>0.24014, 2008=>0.5357, 2009=>0.598, 2010=>0.64019, 2011=>0.672, 2012=>0.695, 2013=>0.70263, 2014=>0.74118}
    expected = {2007=>0.992, 2006=>1.05, 2005=>0.961, 2004=>1.258, 2008=>0.718, 2009=>0.652, 2010=>0.681, 2011=>0.728, 2012=>0.689, 2013=>0.694, 2014=>0.661}
    assert_equal expected, @headcount_analyst.year_comparer(data_set_one, data_set_two)
  end
end
