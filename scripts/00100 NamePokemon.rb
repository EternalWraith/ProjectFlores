# @param db_symbol [Symbol] Symbol of pokemon
# @return [String] Name of pokemon
def pokemon_name(db_symbol)
    return data_creature(db_symbol).name
end