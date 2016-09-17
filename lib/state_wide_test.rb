class StateWideTest
  attr_reader :name,
              :third_grade,
              :eighth_grade,
              :math,
              :reading,
              :writing,
              :state_wide_testing
  def initialize(name, parent_repository)
    @name = name.upcase
    @third_grade         = Hash.new(Hash.new)
    @eighth_grade        = Hash.new(Hash.new)
    @math                = Hash.new(Hash.new)
    @reading             = Hash.new(Hash.new)
    @writing             = Hash.new(Hash.new)
    @state_wide_testing  = parent_repository
  end
end
