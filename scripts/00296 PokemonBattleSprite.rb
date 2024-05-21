module BattleUI
    class PokemonSprite
    
        def initialize(viewport, scene)
            super(viewport)
            @shadow = ShaderedSprite.new(viewport)
            #@shadow.shader = Shader.create(:battle_shadow)
            @animation_handler = Yuki::Animation::Handler.new
            @bank = 0
            @position = 0
            @scene = scene
        end

        def load_battler
            if @last_pokemon&.id != @pokemon.id || @last_pokemon&.form != @pokemon.form || @last_pokemon&.code != @pokemon.code
                bitmap.dispose if @gif
                remove_instance_variable(:@gif) if instance_variable_defined?(:@gif)
                gif = pokemon.bank != 0 ? pokemon.gif_face : pokemon.gif_back
                if gif
                    @gif = gif
                    self.bitmap = Texture.new(gif.width, gif.height)
                    gif.draw(bitmap)
                else
                    self.bitmap = pokemon.bank != 0 ? pokemon.battler_face : pokemon.battler_back
                    if @pokemon.db_symbol == :spinda then
                        if @pokemon.bank != 0 then
                            self.shader = Shader.create(:spinda_spots)
                            p1 = [((@pokemon.code >> 28) & 0xF).to_f, ((@pokemon.code >> 24) & 0xF).to_f]
                            p2 = [((@pokemon.code >> 20) & 0xF).to_f, ((@pokemon.code >> 16) & 0xF).to_f]
                            p3 =  [((@pokemon.code >> 12) & 0xF).to_f, ((@pokemon.code >> 8) & 0xF).to_f]
                            p4 =  [((@pokemon.code >> 4) & 0xF).to_f, ((@pokemon.code >> 0) & 0xF).to_f]
                            self.shader.set_float_uniform("Part1", p1)
                            self.shader.set_float_uniform("Part2", p2)
                            self.shader.set_float_uniform("Part3", p3)
                            self.shader.set_float_uniform("Part4", p4)
                            log_info("Enemy Spinda #{@pokemon.code} = #{p1}, #{p2}, #{p3}, #{p4}")
                            self.shader.set_bool_uniform("shiny", @pokemon.shiny)
                        end
                    else
                        self.shader = Shader.create(:genetic_hue)
                        self.shader.set_texture_uniform("mask", @pokemon.bank != 0 ? @pokemon.battler_mask : @pokemon.battler_back_mask)
                        self.shader.set_float_uniform("geneHue", @pokemon.hue)
                    end
                end
            end
            @last_pokemon = @pokemon.clone

            self.visible = true;
        end

        def visible=(visible)
            log_info("#{@pokemon.db_symbol} Shader #{self.shader}")
            @shadow.visible = false
            super
        end
    end
end