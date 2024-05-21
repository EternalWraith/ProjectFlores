module PFM
    class PokemonBattler
        COPIED_PROPERTIES = %i[@id @form @given_name 
        @code @ability @nature
        @iv_hp @iv_atk @iv_dfe @iv_spd @iv_ats @iv_dfs
        @ev_hp @ev_atk @ev_dfe @ev_spd @ev_ats @ev_dfs
        @trainer_id @trainer_name @step_remaining @loyalty
        @exp @hp @status @status_count @item_holding 
        @captured_with @captured_in @captured_at @captured_level
        @gender @skill_learnt @ribbons @character @exp_rate @hp_rate
        @egg_at @egg_in @acode @color]

        TRANSFORM_BP_METHODS = %i[ability weight height 
        type1 type2 
        gender shiny 
        atk_basis dfe_basis ats_basis dfs_basis spd_basis
        atk_stage dfe_stage ats_stage dfs_stage spd_stage
        apex hue]

=begin
        def apex?
            return (@acode & 0xFFFF) < 16 || @apex
        end
        alias apex apex?

        def shiny?
            return (@code & 0xFFFF) < 16 || @shiny
        end
        alias shiny shiny?
=end
    end
end