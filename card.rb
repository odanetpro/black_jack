# frozen_string_literal: true

class Card
  attr_reader :name, :points

  def initialize(name, points)
    @name = name
    @points = points
  end
end
