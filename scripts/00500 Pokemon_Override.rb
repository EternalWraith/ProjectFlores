module PFM
    class Pokemon 
        # List of pokemon with Apex forms, and what their form number is
        # format = :db_symbol => [from, to]
        APEXES = {:teddiursa => [0, 1], :ursaring => [0, 1]}

        def initialize(id, level, force_shiny = false, no_shiny = false, form = -1, opts = {})
            primary_data_initialize(id, level, force_shiny, no_shiny)
            self.apex = opts[:apex]
            #genetic_data_initialize(opts)
            catch_data_initialize(opts)
            form_data_initialize(form)
            stat_data_initialize(opts)
            moves_initialize(opts)
            item_holding_initialize(opts)
            ability_initialize(opts)
        end

        def primary_data_initialize(id, level, force_shiny, no_shiny)
            real_id = id.is_a?(Symbol) ? data_creature(id).id : id.to_i
            log_error("Bad Pokémon ID (#{id}) - Ignore if you opened the Pokedex") if real_id == 0
            @id = real_id
            @db_symbol = data_creature(real_id).db_symbol
            code_initialize
            self.shiny = force_shiny if force_shiny
            self.shiny = !no_shiny if no_shiny
            @level = level.clamp(1, Float::INFINITY)
            @step_remaining = 0
            @ribbons = []
            @skill_learnt = []
            @skills_set = []
            @sub_id = nil
            @sub_code = nil
            @sub_form = nil
            @status = 0
            @status_count = 0
            @battle_stage = Array.new(7, 0)
            @position = 0
            @battle_turns = 0
            @mega_evolved = false
        end

        def genetic_data_initialize(opts)
            log_info(opts)
            @genetics = {"apex" => opts[:apex] || false}
        end

        def form_data_initialize(form)
            form = form_generation(form)
            form = 0 if data_creature(db_symbol).forms.none? { |creature_form| creature_form.form == form }
            if apex? then
                if APEXES.include?@db_symbol then # Does it have an Apex?
                    log_info("#{@db_symbol} does have an Apex")
                    if APEXES.any?{ |i, v| v[0] == form } then # Is it the right form?
                        log_info("#{form} is the correct form")
                        form = APEXES[@db_symbol][1]
                    end
                end
            end
            @form = form
            exp_initialize
        end

        def code_initialize
            shiny_attempts.clamp(1, Float::INFINITY).times do
                @code = rand(0xFFFF_FFFF)
                break if shiny
            end
            apex_attempts.clamp(1, Float::INFINITY).times do
                @acode = rand(0xFFFF_FFFF)
                break if apex
            end
            log_info("Shiny? #{shiny}; Apex? #{apex}")
        end

        def apex_attempts
            n = 1
            n += 2 if $bag.contain_item?(:shiny_charm)
            n += $game_variables[Yuki::Var::ApexRolls]
            log_info("Monkey Patch for Apex; additional rolls #{$game_variables[Yuki::Var::ApexRolls]}")
            return n
        end

        def shiny_attempts
            n = 1
            n += 2 if $bag.contain_item?(:shiny_charm)
            n += 2 * $wild_battle.compute_fishing_chain
            n += $game_variables[Yuki::Var::ShinyRolls]
            log_info("Monkey Patch for Shiny; additional rolls #{$game_variables[Yuki::Var::ShinyRolls]}")
            return n
        end

        def shiny?
            return (@code & 0xFFFF) < shiny_rate || @shiny
        end
        alias shiny shiny?

        # Set the shiny attribut
        # @param shiny [Boolean]
        def shiny=(shiny)
            @code = (@code & 0xFFFF0000) | (shiny ? 0 : 0xFFFF)
        end

        def apex?
            return (@acode & 0xFFFF) < shiny_rate || @apex
        end
        alias apex apex?

        # Set the shiny attribut
        # @param shiny [Boolean]
        def apex=(apex)
            @acode = (@acode & 0xFFFF0000) | (apex ? 0 : 0xFFFF)
        end
    end
end