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

    # Play the cry of a Pokemon
  # @param id [Integer, Symbol] the id of the Pokemon in the database
  # @param volume [Integer] the volume of the cry
  # @param tempo [Integer] the tempo/pitch of the cry
  def cry_pokemon(id, prefix: "", suffix: "", volume: 100, tempo: 100)
        creature = data_creature(id)
        raise "Database Error : The Pokémon \##{id} doesn't exists." if creature.db_symbol == :__undef__
        Audio.se_play("Audio/SE/Cries/#{prefix}#{format('%04d', creature.id)}#{suffix}Cry", volume, tempo)
  end
end