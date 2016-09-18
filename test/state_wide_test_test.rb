require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/state_wide_test_repository'
require './lib/statewide_test'
require 'pry'

class StatewideTestTest < Minitest::Test

  def setup
    @state_wide_testing = StatewideTest.new("name", "parent repo")
      @state_wide_repo = StatewideTestRepository.new
      @state_wide_repo.load_data({
                        :enrollment        => { :kindergarten => "./data/Kindergartners in full-day program.csv",
                                                :high_school_graduation => "./data/High school graduation rates.csv"},
                        :statewide_testing => { :third_grade  => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                                                :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                                                :math         => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                                                :reading      => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                                                :writing      => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"}})
      @colorado = @state_wide_repo.state_wide_testings["COLORADO"]
  end

  def test_test_state_wide_testing_repo_is_a_class
      assert_equal StatewideTest, @state_wide_testing.class
  end

  def test_it_has_a_name
    assert_equal "NAME", @state_wide_testing.name
  end

  def test_third_grade_scoring_initializes_with_empty_hash
    assert @state_wide_testing.third_grade.values.empty?
  end

  def test_can_add_to_third_grade

  end

  def test_third_grade_initializes_with_empty_hash
    assert @state_wide_testing.third_grade.values.empty?
  end

  def test_eight_grade_score_initializes_with_empty_hash
    assert @state_wide_testing.eighth_grade.values.empty?
  end

  def test_math_initializes_with_empty_hash
    assert @state_wide_testing.math.values.empty?
  end

  def test_reading_test_initializes_with_empty_hash
    assert @state_wide_testing.reading.values.empty?
  end

  def test_writing_initializes_with_empty_hash
    assert @state_wide_testing.writing.values.empty?
  end

  def test_it_knows_it_is_proficient_by_third_grade
    expected = {2008=>{:math=>0.697, :reading=>0.703, :writing=>0.501}, 2009=>{:math=>0.691, :reading=>0.726, :writing=>0.536}, 2010=>{:math=>0.706, :reading=>0.698, :writing=>0.504}, 2011=>{:math=>0.696, :reading=>0.728, :writing=>0.513}, 2012=>{:math=>0.71, :reading=>0.739, :writing=>0.525}, 2013=>{:math=>0.722, :reading=>0.732, :writing=>0.509}, 2014=>{:math=>0.715, :reading=>0.715, :writing=>0.51}}
    assert_equal expected, @colorado.proficient_by_grade(3)
  end

  def test_it_knows_it_is_proficient_by_eighth_grade
    expected = {2008=>{:math=>0.469, :reading=>0.703, :writing=>0.529}, 2009=>{:math=>0.499, :reading=>0.726, :writing=>0.528}, 2010=>{:math=>0.51, :reading=>0.679, :writing=>0.549}, 2011=>{:math=>0.513, :reading=>0.67, :writing=>0.543}, 2012=>{:math=>0.515, :reading=>0.671, :writing=>0.548}, 2013=>{:math=>0.514, :reading=>0.668, :writing=>0.557}, 2014=>{:math=>0.523, :reading=>0.663, :writing=>0.561}}
    assert_equal expected, @colorado.proficient_by_grade(8)
  end

  def test_dummy
    testing = @state_wide_repo.state_wide_testings["AULT-HIGHLAND RE-9"]
    assert_raises UnknownDataError do
    testing.proficient_by_grade(1)
    end
  end

  def test_proficient_by_race_and_ethnicity
    testing = @state_wide_repo.find_by_name("WOODLAND PARK RE-2")
    expected = {2011=>{:math=>0.451, :reading=>0.688, :writing=>0.503}, 2012=>{:math=>0.467, :reading=>0.75, :writing=>0.528}, 2013=>{:math=>0.473, :reading=>0.738, :writing=>0.531}, 2014=>{:math=>0.418, :reading=>0.006, :writing=>0.453}}
   assert_equal expected, testing.proficient_by_race_or_ethnicity(:hispanic)
  end

  def test_can_return_unknown_data_error_if_subject_doesnt_exist
    assert_raises UnknownDataError do
    @colorado.proficient_for_subject_by_grade_in_year(:science, 3, 2008)
    end
  end

  def test_can_return_unknown_data_error_if_grade_doest_exist
    assert_raises UnknownDataError do
    @colorado.proficient_for_subject_by_grade_in_year(:math, 5, 2008)
    end
  end

  def test_can_return_unknown_data_error_if_year_doest_exist
    assert_raises UnknownDataError do
    @colorado.proficient_for_subject_by_grade_in_year(:math, 3, 2016)
    end
  end


  def test_proficient_for_subject_by_race_in_year
    testing = @state_wide_repo.find_by_name("ACADEMY 20")

      assert_equal 0.653, testing.proficient_for_subject_by_grade_in_year(:math, 8, 2011)
  end

  def test_proficient_for_subject_by_race_in_year
    testing = @state_wide_repo.find_by_name("AULT-HIGHLAND RE-9")

    assert_equal 0.611, testing.proficient_for_subject_by_race_in_year(:math, :white, 2012)
    assert_equal 0.310, testing.proficient_for_subject_by_race_in_year(:math, :hispanic, 2014)
    assert_equal 0.794, testing.proficient_for_subject_by_race_in_year(:reading, :white, 2013)
    assert_equal 0.278, testing.proficient_for_subject_by_race_in_year(:writing, :hispanic, 2014)
  end

  def test_basic_proficiency_by_race

    testing = @state_wide_repo.find_by_name("ACADEMY 20")
    expected = { 2011 => {math: 0.816, reading: 0.897, writing: 0.826},
                 2012 => {math: 0.818, reading: 0.893, writing: 0.808},
                 2013 => {math: 0.805, reading: 0.901, writing: 0.810},
                 2014 => {math: 0.800, reading: 0.855, writing: 0.789},
               }
    assert_equal expected, testing.proficient_by_race_or_ethnicity(:asian)
  end

  def test_basic_proficiency_by_grade
    testing = @state_wide_repo.find_by_name("ACADEMY 20")
    expected = { 2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
                 2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
                 2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
                 2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
                 2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
                 2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
                 2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
               }

    assert_equal expected, testing.proficient_by_grade(3)
  end

  # def test_dummy
  #
  #   testing = @state_wide_repo.find_by_name("COTOPAXI RE-3")
  #
  #   assert_equal 0.13, testing.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
  # end

end
