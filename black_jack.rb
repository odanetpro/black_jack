# frozen_string_literal: true

class BlackJack
  GAME_BET = 10
  START_BANK = 100
  LIMIT_POINTS = 21

  def initialize(interface)
    @interface = interface
    @deck = Deck.new
    @players = {}

    @players[:user] = Player.new(@interface.ask_name, START_BANK, GAME_BET, @deck)
    @players[:dealer] = Dealer.new('Дилер', START_BANK, GAME_BET, @deck)
  end

  def play
    loop do
      preparing
      game
      @interface.show_cards(@players)
      summing_up
      @interface.show_players_bank(@players)
      exit unless @interface.ask_play_again?
    end
  end

  private

  def preparing
    @game_con = 0
    @deck = Deck.new

    @players.each_value do |player|
      player.new_game
      @game_con += GAME_BET
    end
  rescue RuntimeError => e
    @interface.show_message e.message.to_s
    exit
  end

  def game
    @interface.show_game_field(@players)

    # ход игрока
    case @interface.ask_human_turn
    when 2
      @players[:user].add_card
    when 3
      return
    end

    # ход компьютера
    @interface.show_message "\n#{@players[:dealer].turn}"

    three_cards? ? return : game
  end

  def summing_up
    who_wins = winner

    if who_wins
      @interface.show_message "\nПобедил #{who_wins.name}\n\n"
      who_wins.get_win(@game_con)
    else
      @interface.show_message "\nНичья\n\n"
      @players.each_value { |player| player.get_win(@game_con / 2) }
    end
  end

  def winner
    players = @players.values.select { |player| player.count_points <= LIMIT_POINTS }

    case players.size
    when 1
      players[0]
    when 2
      player_with_most_points(players)
    end
  end

  def player_with_most_points(players)
    return if players[0].count_points == players[1].count_points

    players[0].count_points > players[1].count_points ? players[0] : players[1]
  end

  def three_cards?
    @players.each_value { |player| return true if player.cards.size == 3 }
    false
  end
end
