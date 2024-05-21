module PFM
    class Pokemon 

        attr_accessor :apex

        attr_accessor :hue
        # List of pokemon with Apex forms, and what their form number is
        # format = :db_symbol => [from, to]
        APEXES = {
            #:db_symbol => [base form, apex form]
            :teddiursa => [0, 1],
             :ursaring => [0, 1]
        }

        # List of pokemon with Variant appearances
        # format = :db_symbol => list of forms with variants
        VARIANTS = {
            :graveler => {1 => [-30, 15]},
            :tyranitar => {0 => [-45, 65]},
            :pidove => {0 => [-35, 160]}
        }

        def initialize(id, level, force_shiny = false, no_shiny = false, form = -1, opts = {})
            primary_data_initialize(id, level, force_shiny, no_shiny)
            self.apex = opts[:apex]
            self.hue = opts[:hue]
            catch_data_initialize(opts)
            form_data_initialize(form)
            stat_data_initialize(opts)
            moves_initialize(opts)
            item_holding_initialize(opts)
            ability_initialize(opts)
            if !opts[:hue] then
                self.hue = randomhue
            end
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

        def form_data_initialize(form)
            form = form_generation(form)
            form = 0 if data_creature(db_symbol).forms.none? { |creature_form| creature_form.form == form }
            if apex? then
                if APEXES.include?@db_symbol then # Does it have an Apex?
                    log_info("#{@db_symbol} does have an Apex")
                    if APEXES[@db_symbol][0] == form then # Is it the right form?
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

            log_info("Shiny? #{shiny}; Apex? #{apex}; Hue? #{hue}")
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

        def hue
            return @color
        end

        def hue=(hue)
            @color = hue
        end

        def randomhue
            if VARIANTS.include?db_symbol then
                if VARIANTS[@db_symbol].include?form then
                    mn = VARIANTS[@db_symbol][form][0]
                    mx = VARIANTS[@db_symbol][form][1]
                    log_info("Random colour between #{mn} and #{mx} generated")
                    return rand(mn..mx)
                end
            end
            return 0
        end

        def battler_mask
            if VARIANTS.include?db_symbol then
                if VARIANTS[@db_symbol].include?form then
                    return RPG::Cache.poke_front(PFM::Pokemon.front_filename(id, form, female?, 0, egg?) + "_mask")
                end
            end
            return RPG::Cache.poke_front(PFM::Pokemon.front_filename(0, 0, female?, 0, egg?) + "_mask") if !VARIANTS.include?(db_symbol)
        end

        def battler_back_mask
            if VARIANTS.include?db_symbol then
                if VARIANTS[@db_symbol].include?form then
                    return RPG::Cache.poke_back(PFM::Pokemon.front_filename(id, form, female?, 0, egg?) + "_mask")
                end
            end
            return RPG::Cache.poke_back(PFM::Pokemon.front_filename(0, 0, female?, 0, egg?) + "_mask") if !VARIANTS.include?(db_symbol)
        end
    end
end