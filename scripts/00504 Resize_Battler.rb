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
            return 242, 138 if enemy?
            return 78, 224
        end
    end
end
