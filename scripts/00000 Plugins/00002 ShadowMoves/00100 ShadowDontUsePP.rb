module Battle
  class Move
    # Return the text of the PP of the skill
    # @return [String]
    def pp_text
      type == data_type(:shadow).id ? "--/--" : "#{@pp} / #{@ppmax}"
    end

    # Decrease the PP of the move
    # @param user [PFM::PokemonBattler]
    # @param targets [Array<PFM::PokemonBattler>] expected targets
    def decrease_pp(user, targets)
      return if user.effects.has?(&:force_next_move?) && !@forced_next_move_
      return false if [*type].map { |t| data_type(t).db_symbol } == [:shadow]

      self.pp -= 1 
      self.pp -= 1 if @logic.foes_of(user).any? { |foe| foe.alive? && foe.has_ability?(:pressure) }
    end

  end
end
