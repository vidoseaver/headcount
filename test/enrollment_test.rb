require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment'


class EnrollmentTest < Minitest::Test
  def setup
    @enrollment = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation =>
      {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
  end


  def test_kindergarten_participation_by_year

      expected = {2010=>0.3915, 2011=>0.35356, 2012=>0.2677}

      assert_equal expected, @enrollment.kindergarten_participation_by_year
  end

  def test_kindergarten_participation_in_year_returns_nil_if_year_doesnt_exist
      assert_equal nil, @enrollment.kindergarten_participation_in_year(1991)
  end

  def test_kindergarten_participation_in_year_returns_specified_year
    assert_equal 0.391, @enrollment.kindergarten_participation_in_year(2010)
  end


  def test_wtt_takes_make_number_into_percentage_by_thousanths
    assert_equal 0.391, @enrollment.wtt(0.3915)
    assert_equal 0.39,  @enrollment.wtt(0.390)
    assert_equal 1, @enrollment.wtt(1)
  end
end
