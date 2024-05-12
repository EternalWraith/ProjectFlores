class Interpreter < Interpreter_RMXP
    def add_specific_pokemon(hash)
        pokemon_id = hash[:id]
        case pokemon_id
        when Integer
        raise "Database Error : The Pokémon \##{pokemon_id} doesn't exists." if each_data_creature.none? { |creature| creature.id == pokemon_id }
        when Symbol
        raise "Database Error : The Pokémon with db_symbol #{pokemon_id} doesn't exists." if each_data_creature.none? { |creature| creature.db_symbol == pokemon_id }
        end
        return add_pokemon(PFM::Pokemon.generate_from_hash(hash))
    end
end