RPG::Cache::LOADS << :load_poke_mask
module RPG
    module Cache

        Pokedex_PokeMask_Path = 'pokedex/pokemask'

        module_function
        def load_poke_mask(flush_it = false)
            if flush_it
                dispose_bitmaps_from_cache_tab(@poke_mask_cache)
            else
                @poke_mask_cache = {}
                @poke_mask_data = Yuki::VD.new(PSDK_PATH + '/master/poke_mask', :read)
            end
        end


        def poke_mask_exist?(filename)
            test_file_existence(filename, Pokedex_PokeMask_Path, @poke_mask_data)
        end

        def poke_mask(filename)
            load_image(@poke_mask_cache, filename, Pokedex_PokeMask_Path, @poke_mask_data)
        end
    end
end
