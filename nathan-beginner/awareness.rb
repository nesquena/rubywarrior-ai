module Awareness
  def required_health(direction=:forward)
    health_map = { 's' => 8, 'S' => 14, 'a' => 6, 'w' => 8 }
    next_enemy = @warrior.look(direction).find { |s| s.enemy? }
    return 12 unless next_enemy && health_map.has_key?(next_enemy.character)
    health_map[next_enemy.character]
  end
  
  def can_escape_enemy_range?
    retreat_space_count = @warrior.look(:backward).count { |s| s.empty? } || 0
    distance_to_nearest_enemy = @warrior.look(:forward).index { |s| s.enemy? } || 0
    retreat_space_count + distance_to_nearest_enemy >= 3
  end

  def next_occupied_is_ranged?(direction=:forward)
    next_occupied_is_type?(/(a|w)/, direction)
  end

  def next_occupied_is_shootable?(direction=:forward)
    next_occupied_is_type?(/(S|w)/, direction)
  end

  def next_occupied_is_captive?(direction=:forward)
    next_occupied_is_type?(/C/, direction)
  end

  def next_occupied_is_stairs?(direction=:forward)
    next_occupied_is_type?(/\>/, direction)
  end

  def next_occupied_is_wall?(direction=:forward)
    @warrior.feel.wall? || (@warrior.look[0].empty? && !@warrior.look[0].stairs? && @warrior.look[1].wall?)
  end

  def next_occupied_is_type?(type, direction=:forward)
    next_occupied = first_occupied_space(direction)
    next_occupied && next_occupied.character =~ type
  end

  def first_occupied_space(direction=:forward)
    @warrior.look(direction).find { |s| !s.empty? || s.character == '>' }
  end
end
