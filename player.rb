# frozen_string_literal: true

class Player
  attr_reader :name, :cards, :bank

  def initialize(name, bank, bet, deck)
    @name = name
    @bank = bank
    @bet = bet
    @deck = deck
  end

  def dealer?
    is_a?(Dealer)
  end

  def new_game
    @cards = []
    dealing
    beting
  end

  def add_card
    @cards << @deck.give_card if @cards.size < 3
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

  def info
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
    make_bet
  rescue RuntimeError => e
    puts e.message.to_s
    exit
  end

  def make_bet
    raise "\nУ игрока: #{name} недостаточно денег чтобы продолжать игру!" if (bank - @bet).negative?

    self.bank -= @bet
  end
end
