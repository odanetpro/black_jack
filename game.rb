# frozen_string_literal: true

require './card'
require './deck'
require './player'

def start_new_game
  @game_con = 0
  @deck.new_deck

  @players.each_value do |player|
    player.new_game
    dealing player
    beting player, GAME_BET
  end
end

def dealing(player)
  2.times { player.add_card(@deck.give_card) }
end

def beting(player, bet)
  player.make_bet(bet)
  @game_con += bet
rescue RuntimeError => e
  puts e.message.to_s
  exit
end

def display_game_field
  @players.each_value do |player|
    player.dealer? ? show_hidden_player_info(player) : show_player_info(player)
  end
end

def show_player_info(player)
  puts "#{player.name}: #{player_cards(player)} Очки: #{player.count_points} "
end

def player_cards(player)
  player.cards.map(&:name).join(' ')
end

def show_hidden_player_info(player)
  print "#{player.name}: "
  player.cards.each { print '* ' }
end

def human_turn(player)
  print "\n\n1 - пропустить, 2 - взять карту, 3 - открыть карты? "
  input = gets.to_i
  puts

  case input
  when 2
    player.add_card @deck.give_card
  when 3
    open_cards
  end
end

def computer_turn(player)
  if player.count_points < 17
    player.add_card @deck.give_card
    puts "дилер берет карту...\n\n"
  else
    puts "дилер пропускает ход...\n\n"
  end
end

def open_cards
  @players.each_value { |player| show_player_info player }
  results
end

def results
  who_wins = winner
  if who_wins
    puts "Победил #{who_wins.name}"
  else
    puts 'Ничья'
  end
  exit
end

def winner
  players = @players.values.select { |player| player.count_points <= 21 }

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

GAME_BET = 10
START_BANK = 100

@deck = Deck.new
@players = {}

# puts "Добро пожаловать в казино! Как вас зовут?"
# @user = Player.new(gets.strip.capitalize, START_BANK)
@players[:user] = Player.new('Игрок', START_BANK, :user)
@players[:dealer] = Player.new('Дилер', START_BANK, :dealer)

start_new_game

loop do
  open_cards if three_cards?

  display_game_field
  human_turn @players[:user]
  computer_turn @players[:dealer]
end
