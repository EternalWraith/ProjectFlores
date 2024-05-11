module PFM
    class Pokemon

        def shiny_attempts
            n = 1
            n += 2 if $bag.contain_item?(:shiny_charm)
            n += 2 * $wild_battle.compute_fishing_chain
            n += $game_variables[Yuki::Var::Rolls]
            log_info("Monkey Patch for Shiny; additional rolls #{$game_variables[Yuki::Var::Rolls]}")
            return n
        end
    end
end