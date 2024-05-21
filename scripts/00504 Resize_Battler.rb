module BattleUI
    # Sprite of a Pokemon in the battle
    class PokemonSprite < ShaderedSprite
        # Pokemon sprite zoom
        # @return [Integer]
        def sprite_zoom
            return enemy? ? 1 : 2
        end


        # Get the base position of the Pokemon in 1v1
        # @return [Array(Integer, Integer)]
        def base_position_v1
            return 248, 114 if enemy?
            return 86, 196
        end
    end
end
