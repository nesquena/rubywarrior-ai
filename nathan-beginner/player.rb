require 'awareness'
require 'decider'

class Turn < Decider
  decide(:rescue)  { warrior.feel.captive? }
  decide(:attack)  { warrior.feel.enemy? }
  decide(:shoot)   { warrior.feel.empty? && next_occupied_is_shootable? && !next_occupied_is_ranged?(:backward) }
  decide(:pivot)   { next_occupied_is_wall? || next_occupied_is_captive?(:backward) }
  decide(:retreat) { next_occupied_is_ranged? && can_escape_enemy_range? && warrior.health < required_health }
  decide(:rest)    { !next_occupied_is_stairs? && !next_occupied_is_captive? && warrior.health < required_health }
  decide(:walk)    { true }
  
  action(:retreat) { |w| w.walk!(:backward)  }
end

class Player
  def play_turn(warrior)
    Turn.new(warrior).execute
  end
end