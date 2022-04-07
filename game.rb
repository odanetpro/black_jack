# frozen_string_literal: true

require './card'
require './deck'
require './player'

def new_game
  @deck.new_deck
  @player.new_game
  @dealer.new_game
end

def dealing(player)
  player.add_card(@deck.give_card)
  player.add_card(@deck.give_card)
end

def beting(player)
  player.make_bet(10)
rescue e
  puts e.message.to_s
  exit
end

def display_field
  # очистка экрана
  puts "\e[H\e[2J"

  # puts "Вы: #{@player.cards} Очки: #{@player.count_points}"
end

@deck = Deck.new
@gamer = Player.new
@dealer = Player.new
@game_con = 0

dealing(@gamer)
beting(@gamer)

dealing(@dealer)
beting(@dealer)

# display_field
p @gamer.count_points
p @dealer.count_points
