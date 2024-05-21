module UI
    class PokemonFaceSprite 
        def initialize(viewport, auto_align = true)
            super(viewport)
            @auto_align = auto_align
            @gif_reader = nil
        end

        def data=(pokemon)
            if (self.visible = (pokemon ? true : false))
                bmp = self.bitmap = load_bitmap(pokemon)
                mbmp = load_mask_bitmap(pokemon)
                if pokemon.db_symbol == :spinda then
                    self.shader = Shader.create(:spinda_spots)
                    p1 = [((pokemon.code >> 28) & 0xF).to_f, ((pokemon.code >> 24) & 0xF).to_f]
                    p2 = [((pokemon.code >> 20) & 0xF).to_f, ((pokemon.code >> 16) & 0xF).to_f]
                    p3 =  [((pokemon.code >> 12) & 0xF).to_f, ((pokemon.code >> 8) & 0xF).to_f]
                    p4 =  [((pokemon.code >> 4) & 0xF).to_f, ((pokemon.code >> 0) & 0xF).to_f]
                    shader.set_float_uniform("Part1", p1)
                    shader.set_float_uniform("Part2", p2)
                    shader.set_float_uniform("Part3", p3)
                    shader.set_float_uniform("Part4", p4)
                    shader.set_bool_uniform("shiny", pokemon.shiny)
                else 
                    self.shader = Shader.create(:genetic_hue)
                    shader.set_texture_uniform("mask", mbmp)
                    shader.set_float_uniform("geneHue", pokemon.hue)
                end
                auto_align(bmp, pokemon) if @auto_align
                log_info("Monkeyed FaceSprite");
            end
        end

        def load_mask_bitmap(pokemon)
            return pokemon.send(:battler_mask)
        end
    end
end