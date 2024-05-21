=begin
module GamePlay
    class Genetics < BaseCleanUpdate::FrameBalanced
        KEYS = [%i[DOWN LEFT RIGHT B], %i[DOWN LEFT RIGHT B], %i[A LEFT RIGHT B], %i[A LEFT RIGHT B], %i[A LEFT RIGHT B], %i[A LEFT RIGHT B]]

        def initialize(pokemon, mode = :view, party = [pokemon], extend_data = nil)
            super()
            @pokemon = pokemon
            @mode = mode
            @party = party 
            @index = mode == :skill ? 2 : 0
            @party_index = party.index(pokemon).to_i
            @skill_selected = -1
            @skill_index = -1
            @selecting_move = false
            @extend_data = extend_data
        end 

        private
        def create_graphics
            create_viewport
            create_base
            create_uis
            create_top_ui
            update_pokemon
        end

        def create_base
            @base_ui = UI::GenericBaseMultiMode.new(@viewport, load_texts, KEYS, ctrl_id_state)
            init_win_text
        end

        def create_uis
            @uis = [UI::Genetics_Biology.new(@viewport), UI::Genetics_Offence.new(@viewport), UI::Genetics_Defence.new(@viewport)]
        end

        def create_top_ui
            @top = UI::Genetics_Side.new(@viewport)
        end

        def init_win_text
            @base_ui.show_win_text("Hehe haha hoo hoo")
        end

        def update_ui_visibility
            @uis.each_with_index { |ui, index| ui.visibile = index == @index }
            update_ctrl_state
        end

        def update_pokemon
            @uis.each { |ui| ui.data = @pokemon }
            @top.data = @pokemon
            Audio.se_play(@pokemon.cry) unless @pokemon.egg?
            update_ui_visibility
=end        

module GamePlay
    class Summary < BaseCleanUpdate::FrameBalanced
        LAST_STATE = 3
        TEXT_INDEXES = [
            # [LEFT BUTTON, PREVIOUS PAGE, NEXT PAGE, EXIT]
            [112, 169, 114, 115],
            [112, 116, 113, 115],
            [117, 114, 169, 115],
            [118, nil, nil, 13],
            [119, nil, nil, 13],
            [nil, nil, nil, 13],
            [112, 113, 116, 115]
        ]
        KEYS = [
            %i[DOWN LEFT RIGHT B],
            %i[DOWN LEFT RIGHT B],
            %i[A LEFT RIGHT B],
            %i[A LEFT RIGHT B], 
            %i[A LEFT RIGHT B], 
            %i[A LEFT RIGHT B], 
            %i[DOWN LEFT RIGHT B]
        ]
        ACTIONS = [
            %i[mouse_next mouse_left mouse_right mouse_quit],
            %i[mouse_next mouse_left mouse_right mouse_quit],
            %i[mouse_a mouse_left mouse_right mouse_quit], 
            %i[mouse_a object_id object_id mouse_cancel], 
            %i[mouse_a object_id object_id mouse_cancel], 
            %i[object_id object_id object_id mouse_quit],
            %i[mouse_next mouse_left mouse_right mouse_quit]
        ]
        
        def create_uis
            @uis = [UI::Summary_Memo.new(@viewport), UI::Summary_Stat.new(@viewport), UI::Summary_Skills.new(@viewport), UI::Summary_Genetics.new(@viewport)]
        end

        def update_inputs_view
            case @index
            when 2
                update_inputs_skill_ui
            else 
                update_inputs_basic
            end
            return true
        end

        def update_pokemon
            @uis.each { |ui| ui.data = @pokemon }
            @top.data = @pokemon
            #log_info("#{@top.data.type2}")
            Audio.se_play(@pokemon.cry) unless @pokemon.egg?
            update_ui_visibility
        end

        def ctrl_id_state
            case @index
            when 0
                return 0
            when 1
                return 1
            when 2
                return 5 if @mode == :skill
                return 4 if @skill_index >= 0
                return 3 if @selecting_move
                return 2
            when 3
                return 6
            end
            
        end

    end
end 