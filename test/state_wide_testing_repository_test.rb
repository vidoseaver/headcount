require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/state_wide_testing_repository'
require 'pry'



class StateWideTestingRepositoryTest < Minitest::Test

  def test_test_state_wide_testing_repo_is_a_class
      a = StateWideTestingRepository.new

      assert_equal StateWideTestingRepository, a.class
  end
end
