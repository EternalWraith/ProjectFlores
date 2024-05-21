module Battle
    class Visual
      module Transition
        class RBYWild
          # Function that creates the enemy sprites
          def create_enemy_sprites
            log_info("Enemy Sprite Patch");
            @shader = Shader.create(:color_shader)
            @shader.set_float_uniform('color', [0, 0, 0, 1])
            @enemy_sprites = enemy_pokemon_sprites
            @enemy_sprites.each do |sprite|
              if sprite.shader
                log_info("This sprite already has a shader #{sprite.shader}")
                sprite.shader.set_float_uniform('color', [0, 0, 0, 1])
              else
                log_info("This sprite does not have a shader")
                sprite.shader = @shader
              end
              sprite.x -= DISPLACEMENT_X
            end
          end
          
          def create_sprite_move_animation
            ya = Yuki::Animation
            animations = @enemy_sprites.map do |sp|
              ya.move(0.8, sp, sp.x, sp.y, sp.x + DISPLACEMENT_X, sp.y)
            end
            animation = animations.pop
            animations.each { |a| animation.parallel_add(a) }
            @actor_sprites.each do |sp|
              animation.parallel_add(ya.move(0.8, sp, sp.x, sp.y, sp.x - DISPLACEMENT_X, sp.y))
            end
            @enemy_sprites.each { |sp| sp.shader.set_float_uniform("color", [0.0,0.0,0.0,0.0]) }
            cries = @enemy_sprites.select { |sp| sp.respond_to?(:cry) }
            cries.each { |sp| animation.play_before(ya.send_command_to(sp, :cry)) }
            return animation
          end
        end
      end
    end
  end