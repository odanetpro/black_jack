# frozen_string_literal: true

class Player
  attr_reader :cards, :bank

  def initialize
    @bank = 100
    new_game
  end

  def new_game
    @cards = []
  end

  def add_card(card)
    @cards << card
  end

  def make_bet(bet)
    raise 'Недостаточно денег чтобы продолжать игру!' if (bank - bet).negative?

    self.bank -= bet
  end

  def count_points
    points = cards.map(&:points)
    sum = points.sum
    return sum unless points.any?(1)

    sum + 10 <= 21 ? sum + 10 : sum
  end

  private

  attr_writer :bank
end
