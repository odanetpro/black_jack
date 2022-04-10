# frozen_string_literal: true

class Player
  attr_reader :name, :cards, :bank

  def initialize(name, bank, type)
    @name = name
    @bank = bank
    @type = type
    new_game
  end

  def dealer?
    @type == :dealer
  end

  def new_game
    @cards = []
  end

  def add_card(card)
    @cards << card if @cards.size < 3
  end

  def make_bet(bet)
    raise "\nУ игрока: #{name} недостаточно денег чтобы продолжать игру!" if (bank - bet).negative?

    self.bank -= bet
  end

  def get_win(cash)
    self.bank += cash
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
