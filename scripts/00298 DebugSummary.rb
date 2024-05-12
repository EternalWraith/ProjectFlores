module UI
    class Summary_Skills < SpriteStack
        def index=(index)
            index = fix_index(index)
            @skills[@index || 0].selected = false
            @index = index.to_i
            @move_info.data = @data.skills_set[@index] if @data
            log_data(@move_info.data)
            @skills[@index].selected = true
          end

        def init_texts
            texts = text_file_get(27)
            with_surface(114, 19, 95) do
                add_line(0, texts[3])
                add_line(1, texts[36])
                add_line(0, texts[37], dx: 1)
                add_line(1, texts[39], dx: 1)
            end
            @move_info = SpriteStack.new(@viewport)
            @move_info.with_surface(114, 19, 95) do
            @move_info.add_line(0, :power_text, 2, type: SymText, color: 1, dx: 1)
            @move_info.add_line(1, :accuracy_text, 2, type: SymText, color: 1, dx: 1)
            @move_info.add_line(2, :description, type: SymMultilineText, color: 1).width = 195
            end
            @move_info.push(175, 21, nil, type: TypeSprite)
            @move_info.push(175, 21 + 16, nil, type: CategorySprite)
        end

        def update_skills(pokemon)
            pokemon.skills_set.compact!
            @skills.each_with_index do |skill_stack, index|
              skill_stack.data = pokemon.skills_set[index]
              log_info("#{skill_stack.data.type}")
            end
        end
    end
end