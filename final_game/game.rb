require "gosu"
require "./z_order"
require "./player"
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

        @bats = []

        @max_bats = 0

        @max_bats.times do |i|
            @bats.push(Bat.new)
        end

        @blobs = []

        @max_blobs = 10

        @max_blobs.times do |i|
            @blobs.push(Blob.new)
        end
        
        @level = 0
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

            
            if @counter % 10 == 0
                @player.up_score
            end
            
            if @player.score % 100 == 0
                @level += 1
                @max_blobs = @level * 2
                @max_bats = @level
            end

            if @player.score % 25 == 0
                if @blobs.length < @max_blobs

                end
            end
            
            @player.move
            @player.hit_enemy(@blobs, @bats)

            @blobs.each do |blob|
                blob.move()
            end

            @bats.each do |bat|
                bat.move(@player)
            end

            @counter += 1

            
        end

    end
    
    def draw
        @background_image.draw(0, 0, ZOrder::BACKGROUND, 1, 1)
        @player.draw

        @blobs.each do |blob|
            blob.draw
        end

        @bats.each do |bat|
            bat.draw
        end

        @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 2.0, 2.0, Gosu::Color::YELLOW)
    end

end

Final_Game.new.show