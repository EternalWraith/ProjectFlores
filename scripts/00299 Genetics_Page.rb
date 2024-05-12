module UI
    class Summary_Genetics < SpriteStack

        def initialize(viewport)
            super(viewport, 0, 0, default_cache: :interface)
            @invisible_if_egg = []
            init_sprite
        end

        def no_egg(object)
            @invisible_if_egg << object_id
            return object
        end

        def data=(pokemon)
            if (self.visible = !pokemon.nil?)
                super
                @invisible_if_egg.each { |sprite| sprite.visible = false } if pokemon.egg?
                fix_level_text_position
                @isapex = pokemon.apex?
                @isshiny = pokemon.shiny?
                load_text_info(pokemon)
            end
        end

        def visible=(value)
            super
            @invisible_if_egg.each { |sprite| sprite.visible = false } if @data&.egg?
        end

        def init_gene
            with_surface(114, 19, 95) do
                add_line(0, "Genetic Information")
                no_egg add_line(1, "Shiny?")
                if @isshiny then
                    @shinyline = no_egg add_line(1, "Yes", 1)
                    @shinyline.load_color(1)
                else
                    @shinyline = no_egg add_line(1, "No", 1)
                    @shinyline.load_color(2)
                end

                no_egg add_line(1, "Apex?", dx: 1)
                if @isapex then
                    @apexline = no_egg add_line(1, "Yes", 1, dx: 1)
                    @apexline.load_color(1)
                else
                    @apexline = no_egg add_line(1, "No", 1, dx: 1)
                    @apexline.load_color(2)
                end
                    
                #@level_text = no_egg(add_line(1, "thingy", dx: 1))
                #@id = no_egg add_line(1, :id_text, 2, type: SymText, color: 1)
                #@level_value = no_egg(add_line(1, :level_text, 2, type: SymText, color: 1, dx: 1))
            end
        end

        def load_text_info(pokemon)
            return load_egg_text_info(pokemon) if pokemon.egg?
            time = Time.at(pokemon.captured_at)
            time_egg = pokemon.egg_at ? Time.at(pokemon.egg_at) : time
            hash = {'[VAR NUM2(0007)]' => time_egg.strftime('%d'), '[VAR NUM2(0006)]' => time_egg.strftime('%m'), '[VAR NUM2(0005)]' => time_egg.strftime('%y'), '[VAR LOCATION(0008)]' => pokemon.egg_zone_name, '[VAR 0105(0008)]' => pokemon.egg_zone_name, '[VAR NUM3(0003)]' => pokemon.captured_level.to_s, '[VAR NUM2(0002)]' => time.strftime('%d'), '[VAR NUM2(0001)]' => time.strftime('%m'), '[VAR NUM2(0000)]' => time.strftime('%y'), '[VAR LOCATION(0004)]' => pokemon.captured_zone_name, '[VAR 0105(0004)]' => pokemon.captured_zone_name}
            mem = pokemon.memo_text || []
            text = parse_text(mem[0] || 28, mem[1] || 25, hash).gsub(/([0-9.]) ([a-z]+ *)\:/i, "\\1 \n\\2:")
            text.gsub!('Level', "\nLevel") if $options.language == 'en'
            @text_info.multiline_text = text
            #@id.load_color(pokemon.shiny ? 2 : 1)
        end
          # Load the text info when it's an egg
          # @param pokemon [PFM::Pokemon]
        def load_egg_text_info(pokemon)
            time_egg = pokemon.egg_at ? Time.at(pokemon.egg_at) : Time.new
            hash = {'[VAR NUM2(0007)]' => time_egg.strftime('%d'), '[VAR NUM2(0006)]' => time_egg.strftime('%m'), '[VAR NUM2(0005)]' => time_egg.strftime('%y'), '[VAR LOCATION(0008)]' => pokemon.egg_zone_name, '[VAR 0105(0008)]' => pokemon.egg_zone_name, '[VAR NUM3(0003)]' => pokemon.captured_level.to_s, '[VAR LOCATION(0004)]' => pokemon.captured_zone_name, '[VAR 0105(0004)]' => pokemon.captured_zone_name}
            if pokemon.step_remaining > 10_240
                text = parse_text(28, 89, hash).gsub(/([0-9.]) ([a-z]+ *)\:/i) {"#{$1} \n#{$2}:" }
            else
                if pokemon.step_remaining > 2_560
                text = parse_text(28, 88, hash).gsub(/([0-9.]) ([a-z]+ *)\:/i) {"#{$1} \n#{$2}:" }
                else
                if pokemon.step_remaining > 1_280
                    text = parse_text(28, 87, hash).gsub(/([0-9.]) ([a-z]+ *)\:/i) {"#{$1} \n#{$2}:" }
                else
                    text = parse_text(28, 86, hash).gsub(/([0-9.]) ([a-z]+ *)\:/i) {"#{$1} \n#{$2}:" }
                end
            end
        end
        text.gsub!('Level', "\nLevel") if $options.language == 'en'
        @text_info.multiline_text = text
        end

        def fix_level_text_position
            #@level_text.x = @level_value.x + @level_value.width - @level_value.real_width - @level_text.real_width - 2
        end

        def init_sprite
            create_background
            init_gene
            @text_info = create_text_info
            no_egg @exp_container = push(30, 129, RPG::Cache.interface('exp_bar'))
            no_egg @exp_bar = push_sprite(create_exp_bar)
            @exp_bar.data_source = :exp_rate
        end
        
        def create_background
            push(0, 0, 'summary/genetics')
        end

        def create_text_info
            add_text(13, 138, 294, 16, '')
        end

        def create_exp_bar
            bar = Bar.new(@viewport, 31, 130, RPG::Cache.interface('bar_exp'), 73, 2, 0, 0, 1)
            bar.data_source = :exp_rate
            return bar
        end
    end
end