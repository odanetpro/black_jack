# frozen_string_literal: true

class Player
  ACE = 1
  LIMIT_CARDS = 3
  LIMIT_POINTS = 21
  EXTRA_POINTS = 10

  attr_reader :name, :cards, :bank

  def initialize(name, bank, bet, deck)
    @name = name
    @bank = bank
    @bet = bet
    @deck = deck
  end

  def new_game
    @cards = []
    dealing
    beting
  end

  def add_card
    @cards << @deck.give_card if @cards.size < LIMIT_CARDS
  end

  def get_win(cash)
    self.bank += cash
  end

  def count_points
    points = cards.map(&:points)
    sum = points.sum
    return sum unless points.any?(ACE)

    sum + EXTRA_POINTS <= LIMIT_POINTS ? sum + EXTRA_POINTS : sum
  end

  def info
    open_cards
  end

  def open_cards
    "#{name}: #{player_cards} Очки: #{count_points} "
  end

  protected

  attr_writer :bank

  def player_cards
    cards.map(&:name).join(' ')
  end

  def dealing
    2.times { add_card }
  end

  def beting
    raise "\nУ игрока: #{name} недостаточно денег чтобы продолжать игру!" if (bank - @bet).negative?

    self.bank -= @bet
  end
end
