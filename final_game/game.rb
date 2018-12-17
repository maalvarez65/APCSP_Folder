require "gosu"
require "./z_order"
require "./player"
require "./projectile"
require "./blob"
require "./bat"

class Final_Game < Gosu::Window

    def initialize
        super 1600, 800
        self.caption = "Game"

        @background_image = Gosu::Image.new("media/background.jpg", :tileable => true)
        @font = Gosu::Font.new(20)

        @player = Player.new
        @player.teleport(800, 400)
        @projectile = Projectile.new

        @bats = []

        @max_bats = 1

        @blobs = []

        @max_blobs = 2
        
        @level = 1
        @blob_respawn = 100 / @max_blobs
        @bat_respawn = 100 / @max_bats
        @counter = 0
    end

    def update
        if @player.alive
            if Gosu.button_down?(Gosu::KB_LEFT)
                @player.move_left
            end
            if Gosu.button_down?(Gosu::KB_RIGHT)
                @player.move_right
            end
            if Gosu.button_down?(Gosu::KB_UP)
                @player.move_up
            end
            if Gosu.button_down?(Gosu::KB_DOWN)
                @player.move_down
            end
            if Gosu.button_down?(Gosu::KB_A)
                @projectile.shot_left(@player.x, @player.y)
            end
            if Gosu.button_down?(Gosu::KB_D)
                @projectile.shot_right(@player.x, @player.y)
            end
            if Gosu.button_down?(Gosu::KB_W)
                @projectile.shot_up(@player.x, @player.y)
            end
            if Gosu.button_down?(Gosu::KB_S)
                @projectile.shot_down(@player.x, @player.y)
            end

            
            if @counter % 10 == 0
                @player.up_score

                if @player.score % 100 == 0
                    @level += 1
                    @max_blobs = @level * 2
                    @max_bats = @level
                    @blob_respawn = 100 / @max_blobs
                    @bat_respawn = 100 / @max_bats
                end

                if @player.score % @blob_respawn == 0
                    if @blobs.length < @max_blobs
                        @blobs.push(Blob.new)
                    end
                end

                if @player.score % @bat_respawn == 0
                    if @bats.length < @max_bats
                        @bats.push(Bat.new)
                    end
                end
            end
            
            
            
            @player.move
            @player.hit_enemy(@blobs, @bats)
            @projectile.move
            @projectile.kill_enemy(@blobs, @bats)

            @blobs.each do |blob|
                blob.move()
            end

            @bats.each do |bat|
                bat.move(@player)
            end

            @counter += 1

        elsif Gosu.button_down?(Gosu::KB_SPACE)

            @player.restart
            @projectile.reload
            @bats = []
            
            @max_bats = 1
            
            @blobs = []
            
            @max_blobs = 2
            
            @level = 1
            @blob_respawn = 100 / @max_blobs
            @bat_respawn = 100 / @max_bats
            @counter = 0
        end

    end
    
    def draw
        @background_image.draw(0, 0, ZOrder::BACKGROUND, 1, 1)
        @player.draw
        
        @projectile.draw

        @blobs.each do |blob|
            blob.draw
        end

        @bats.each do |bat|
            bat.draw
        end

        # @font.draw("Score: #{@player.score}, Level test: #{@level},blobs: #{@max_blobs}, bats: #{@max_bats}", 10, 10, ZOrder::UI, 2.0, 2.0, Gosu::Color::YELLOW)
        if @player.alive
            @font.draw("Level: #{@level}\nScore: #{@player.score}", 10, 10, ZOrder::UI, 2.0, 2.0, Gosu::Color::RED)
        else
            @font.draw("Final Level: #{@level}\nFinal Score: #{@player.score}\nPress Space to play again", 600, 300, ZOrder::UI, 2.0, 2.0, Gosu::Color::RED)
        end

        if @player.score < 50
            @font.draw("Controls: WASD to shoot and Arrow Keys to move\nGOOD LUCK!", 450, 300, ZOrder::UI, 2.0, 2.0, Gosu::Color::RED)
        end
    end

end

Final_Game.new.show