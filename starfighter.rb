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
		
		@star_anim = Gosu::Image::load_tiles(self, "media/Star.png", 25, 25, false)
		@stars = Array.new
		
		@font = Gosu::Font.new(self, Gosu::default_font_name, 20)
	end
	
	def update
		@player.turn_left if button_down?(Gosu::KbLeft) || button_down?(Gosu::GpLeft)
		@player.turn_right if button_down?(Gosu::KbRight) || button_down?(Gosu::GpRight)
		@player.accelerate if button_down?(Gosu::KbUp) || button_down?(Gosu::GpButton0)
		@player.move
		@player.collect_stars(@stars)
		
		@stars.push(Star.new(@star_anim)) if rand(100) < 4 && @stars.size < 25
	end
	
	def draw
		@player.draw
		@background_image.draw(0, 0, ZOrder::Background)
		@stars.each {|star| star.draw}
		@font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00)
	end
	
	def button_up(id)
		close if id == Gosu::KbEscape
	end
end

class Player
	def initialize window
		@image  = Gosu::Image.new(window, "media/Starfighter.bmp", false)
		@beep = Gosu::Sample.new(window, "Media/Beep.wav")
		@x = @y = @vel_x = @vel_y = @angle = 0.0
		@score = 0
	end
	
	def score
		@score
	end
	
	def collect_stars(stars)
		stars.reject! do |star|  
			if Gosu::distance(@x, @y, star.x, star.y) < 35 then
				@score += 10
				@beep.play
				true
			else
				false
			end
		end
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

class Star
	attr_reader :x, :y
	
	def initialize(animation)
		@animation = animation
		@color = Gosu::Color.new(0xff000000)
		@color.red = (256 - 40) + 40
		@color.blue = (256 - 40) + 40
		@color.green = (256 - 40) + 40
		@x = rand * 640
		@y = rand * 480
	end
	
	def draw
		img = @animation[Gosu::milliseconds / 100 % @animation.size];
		img.draw(@x - img.width / 2.0, @y - img.height / 2.0, ZOrder::Stars, 1, 1, @color, :add)
	end
end

window = GameWindow.new
window.show