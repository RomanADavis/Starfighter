require "gosu"

module ZOrder
	Background, Stars, Player, UI = *0..3
end

class GameWindow < Gosu::Window
	def initialize
		super(640, 480, false)
		self.caption = "Gosu Tutorial Game"
		
		@background_image = Gosu::Image.new(self, "media/Space.png", true)
		
		@player = Player.new(self)
		@player.warp(320, 240)
	end
	
	def update
		@player.turn_left if button_down?(Gosu::KbLeft) || button_down?(Gosu::GpLeft)
		@player.turn_right if button_down?(Gosu::KbRight) || button_down?(Gosu::GpRight)
		@player.accelerate if button_down?(Gosu::KbUp) || button_down?(Gosu::GpButton0)
		@player.move
	end
	
	def draw
		@player.draw
		@background_image.draw(0, 0, ZOrder::Background)
	end
	
	def button_up(id)
		close if id == Gosu::KbEscape
	end
end

class Player
	def initialize window
		@image  = Gosu::Image.new(window, "media/Starfighter.bmp", false)
		@x = @y = @vel_x = @vel_y = @angle = 0
		@score = 0
	end
	
	def warp x, y
		@x, @y = x, y
	end
	
	def turn_left
		@angle -= 4.5
	end
	
	def turn_right
		@angle += 4.5
	end
	
	def accelerate
		@vel_x += Gosu::offset_x(@angle, 0.5)
		@vel_y += Gosu::offset_y(@angle, 0.5)
	end
	
	def move
		@x += @vel_x
		@y += @vel_y
		@x  = @x % 640
		@y = @y % 480
		
		@vel_x *= 0.95
		@vel_y *= 0.95
	end
	
	def draw
		@image.draw_rot(@x, @y, ZOrder::Player, @angle)
	end
end

window = GameWindow.new
window.show