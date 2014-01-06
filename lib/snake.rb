require 'gosu'
module ZOrder
  Background, Stars, Player, UI = *0..3
end
class GameWindow < Gosu::Window
  def initialize
  	puts "Start Speed: "
  	@start_speed = gets.chomp.to_f
  	@right = false
  	@left  = false
  	@up = false
  	@down = false

  	@shoot_left = false
    @shoot_right = false

  	super(640, 480, true)
  	@background = Gosu::Image.new(self, "lib/background.png", true)
  	@button_img = Gosu::Image::load_tiles(self, "lib/button.png", 20, 20, false)
  	@buttons = Array.new
  	@slow_down = Gosu::Image::load_tiles(self, "lib/slow_down.png", 20, 20, false)
    @slow_down_array = Array.new
    @bullet = Bullet.new(self)
    @player = Player.new(self)
    @player.warp(20, 20)
    @player.speed_start(@start_speed)
    @enemy = Enemy.new(self)
    @enemy.warp(400, 40)
    @enemy_speed = 0.75
    @enemy.speed_start(@enemy_speed)
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @slow_down_sound = Gosu::Sample.new(self, "lib/sounds/slow_down_sound.wav")
    @button_sound = Gosu::Sample.new(self, "lib/sounds/button_sound.wav")
    @number = rand(100000)
    @highscore = File.new("highscores/#{@number}.txt", "w+")
  end
  def update

  	if @buttons.reject! {|button| Gosu::distance(@player.x, @player.y, button.x, button.y) < 20} then
  		@player.add_speed(0.1)
  		@player.add_level
      @button_sound.play
  	end

  	if @slow_down_array.reject! {|slow| Gosu::distance(@player.x, @player.y, slow.x, slow.y) < 20} then
  	  @player.speed_start(rand(6.5) + 1.5)
      @slow_down_sound.play
  	end

  	if Gosu::distance(@player.x, @player.y, @enemy.x, @enemy.y) < 20 then
  		@highscore.puts("Player touched the enemy")
  		@highscore.puts("Highscore: #{@player.level}")
  		close
  	end

  	if @player.not_touched_wall || @player.not_touched_wall_y then
  	@player.move
    end
    @enemy.move
    @bullet.move
    @enemy.follow(@player.x, @player.y)
    #@bullet.warp(@player.x, @player.y)
  	if button_down? Gosu::KbRight then
  		#@player.turn_right
  		@right = true
  		@left = false
  		@up = false
     	@down = false
     	@shoot_left = false
     	@shoot_right = true
  	end
  	if button_down? Gosu::KbLeft then
  		#@player.turn_left
  		@right = false
  		@left = true
  		@up = false
  	    @down = false
  	   	@shoot_left = true
     	@shoot_right = false
  	end
  	if button_down? Gosu::KbUp then
  		#@player.turn_up
  		@right = false
  		@left = false
  		@up = true
     	@down = false
     end
     if button_down? Gosu::KbDown then
     	#@player.turn_down
  		@right = false
  		@left = false
  		@up = false
     	@down = true
     end

      	if button_down? Gosu::GpRight then
  		#@player.turn_right
  		@right = true
  		@left = false
  		@up = false
     	@down = false
     	@shoot_left = false
     	@shoot_right = true
  	end
  	 	if button_down? Gosu::GpLeft then
  		#@player.turn_right
  		@right = false
  		@left = true
  		@up = false
     	@down = false
     	@shoot_left = true
     	@shoot_right = false
  	end
  	 	if button_down? Gosu::GpUp then
  		#@player.turn_right
  		@right = false
  		@left = false
  		@up = true
     	@down = false
  	end
  	 	if button_down? Gosu::GpDown then
  		#@player.turn_right
  		@right = false
  		@left = false
  		@up = false
     	@down = true
  	end
    if button_down? Gosu::GpButton0 then
      @slow_down_sound.play
    end
  	if @right == true then
  		@player.turn_right
  		@bullet.turn_right(@player.speed)
  	end
  	if @left == true then
  		@player.turn_left
  		@bullet.turn_left(@player.speed)
  	end
  	if @up == true then
  		@player.turn_up
  		@bullet.turn_up(@player.speed)
  	end
  	if @down == true then
  		@player.turn_down
  		@bullet.turn_down(@player.speed)
  	end
  	if button_down? Gosu::KbSpace then
  		if @shoot_left == true then
  		@bullet.shoot_left
  	    end
  	end
  	if button_down? Gosu::KbSpace then
  		if @shoot_right == true then
  		@bullet.shoot_right
  	    end
  	end
  	if button_down? Gosu::GpButton0 then
  		if @shoot_left == true then
  		25.times do
  		@bullet.shoot_left
  	    end
  	    end
  	end
  	if button_down? Gosu::GpButton0 then
  		if @shoot_right == true then
  		25.times do
  		@bullet.shoot_right
  		end
  	    end
  	end
  	if button_down? Gosu::GpButton1 then
  		@bullet.warp(@player.x, @player.y)
  	end
  	if @player.touched_wall then
      @highscore.puts("Player died due to touching the right or left walls")
  		@highscore.puts("Highscore: #{@player.level}")
  		close
  	end
  	if @player.touched_wall_y then
      @highscore.puts("Player died due to touching the upper or downer walls")
  		@highscore.puts("Highscore: #{@player.level}")
  		close
  	end
  	def button_down(id)
  		if id == Gosu::KbEscape then
        @highscore.puts("Player closed the game")
  			@highscore.puts("Highscore: #{@player.level}")
  			close
  		end
  	end
  	#if rand(100) >= 50 then
  	#	@enemy.turn_left
  	#end
  	#if rand(10000) < 750 then
  	#	@enemy.turn_up
  	#end
  end

  def draw
  	if @player.touched_wall || @player.touched_wall_y then
  		@background.draw(5,5,5)
  	end
  	@enemy.draw
  	@font.draw("Speed: #{@player.speed}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00)
  	@font.draw("Collected Buttons: #{@player.level}", 10, 30, ZOrder::UI, 1.0, 1.0, 0xffffff00)
  	if @player.touched_wall || @player.touched_wall_y then
  	end
  	 if @buttons.size < 1 then
     	@buttons.push(Button.new(@button_img))
     end
     if @slow_down_array.size < 1 && rand(10000) < 100 then
     	@slow_down_array.push(SlowDown.new(@slow_down))
     end
     @player.draw
  	@buttons.each {|button| button.draw}
  	@slow_down_array.each {|button| button.draw}
  	@background.draw(0,0,0)
  	@bullet.draw
 end

 class Player
  def initialize(window)
    @image = Gosu::Image.new(window, "lib/player.png", false)
    @x = @y = @vel_x = @vel_y = @angle = 0
    @score = 0
    @lives = 0
    @level = 0
    @vy = 0
    @speed = 1.5
  end

  def x
    @x
  end

  def y
    @y
  end

  def level
  	@level
  end

  def add_level
  	@level += 1
  end

  def touched_wall
  	if @x >= 630  then
  		@lives -= 1
  	end
  	if @x <= 10 then
  		@lives -= 1
  	end
  end

  def touched_wall_y
  if @y >= 470 then
  		@lives -= 1
  	end
  	if @y <= 10 then
  		@lives -= 1
  	end
  end

    def not_touched_wall
  	if @x <= 630  then
  		@lives -= 1
  	end
  	if @x >= 10 then
  		@lives -= 1
  	end
  end

  def not_touched_wall_y
  if @y <= 470 then
  		@lives -= 1
  	end
  	if @y >= 10 then
  		@lives -= 1
  	end
  end

  def speed_start(speed)
  	@speed = speed
  end


  def level
  	@level
  end

  def reset
    @x = 0
    @y = 1080 - 32
  end

  def warp(x, y)
    @x, @y = x, y
  end
  
  def turn_left
    @x -= @speed
  end
  
  def turn_right
    @x += @speed
  end 

  def turn_down
  	@y += @speed
  end

 def turn_up
  	@y -= @speed
  end

  def add_speed(speed)
  	@speed += speed
  end

  def speed
  	@speed
  end

  def down
    @score = 0
  end

  def jump
    @y -= 35
  end

  def fall
  	@y += 35
  end

def faller
    @vy += 1
    # Vertical movement
    #if Gosu::distance(@x, @y, block.x, block.y) < 80 then
    if @vy > 0 then
      @vy.times { if @y < 1080 - 60 then @y += 0.2 else @vy = 0 end }
    end
    if @vy < 0 then
      (-@vy).times { if @y > 1080 - 60 then @y -= 0.2 else @vy = 0 end }
    end
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= 640
    @y %= 480
    
    @vel_x *= 0.95
    @vel_y *= 0.95
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end
  def Score
    @score
  end

  def Lives
    @lives
  end

  def collect_button(button)
  	if button.reject! {|button| Gosu::distance(@x, @y, button.x, button.y) < 35} then
  		@got_button.play
  		@level += 1
  	end
  end
end

class Enemy
  def initialize(window)
    @image = Gosu::Image.new(window, "lib/enemy.png", false)
    @x = @y = @vel_x = @vel_y = @angle = 0
    @score = 0
    @lives = 0
    @level = 0
    @vy = 0
    @speed = 0.8
  end

  def x
    @x
  end

  def y
    @y
  end

  def follow(x, y)
    if Gosu::distance(@x, @y, x, y) < 250 then
    if @x < x then
      @x += @speed
    end
    if @x > x then
      @x -= @speed
    end
    if @y < y then
      @y += @speed
    end
    if @y > y then
      @y -= @speed
    end
  end
  end

  def level
  	@level
  end

  def add_level
  	@level += 1
  end

  def touched_wall
  	if @x >= 630  then
  		@lives -= 1
  	end
  	if @x <= 10 then
  		@lives -= 1
  	end
  end

  def touched_wall_y
  if @y >= 470 then
  		@lives -= 1
  	end
  	if @y <= 10 then
  		@lives -= 1
  	end
  end

    def not_touched_wall
  	if @x <= 630  then
  		@lives -= 1
  	end
  	if @x >= 10 then
  		@lives -= 1
  	end
  end

  def not_touched_wall_y
  if @y <= 470 then
  		@lives -= 1
  	end
  	if @y >= 10 then
  		@lives -= 1
  	end
  end

  def speed_start(speed)
  	@speed = speed
  end


  def level
  	@level
  end

  def reset
    @x = 0
    @y = 1080 - 32
  end

  def warp(x, y)
    @x, @y = x, y
  end
  
  def turn_left
    @x -= @speed
  end
  
  def turn_right
    @x += @speed
  end 

  def turn_down
  	@y += @speed
  end

 def turn_up
  	@y -= @speed
  end

  def add_speed(speed)
  	@speed += speed
  end

  def speed
  	@speed
  end

  def down
    @score = 0
  end

  def jump
    @y -= 35
  end

  def fall
  	@y += 35
  end

def faller
    @vy += 1
    # Vertical movement
    #if Gosu::distance(@x, @y, block.x, block.y) < 80 then
    if @vy > 0 then
      @vy.times { if @y < 1080 - 60 then @y += 0.2 else @vy = 0 end }
    end
    if @vy < 0 then
      (-@vy).times { if @y > 1080 - 60 then @y -= 0.2 else @vy = 0 end }
    end
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= 640
    @y %= 480
    
    @vel_x *= 0.95
    @vel_y *= 0.95
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end
  def Score
    @score
  end

  def Lives
    @lives
  end

  def collect_button(button)
  	if button.reject! {|button| Gosu::distance(@x, @y, button.x, button.y) < 35} then
  		@got_button.play
  		@level += 1
  	end
  end
end

class Button
  attr_reader :x, :y
  attr_accessor :des

  def initialize(animation)
  	@x = @y = @vel_x = @vel_y = @angle = 1.0
    @animation = animation
    @color = Gosu::Color.new(0xff000000)
    @color.red = rand(256 - 40) + 40
    @color.green = rand(256 - 40) + 40
    @color.blue = rand(256 - 40) + 40
    @x = rand(620)
    @y = rand(460)
    @des = "test"
  end

  def des
  	puts @des
  end

  def draw  
    img = @animation[Gosu::milliseconds / 100 % @animation.size];
    img.draw(@x - img.width / 2.0, @y - img.height / 2.0,
        ZOrder::Stars, 1, 1)
  end
end

class SlowDown
  attr_reader :x, :y
  attr_accessor :des

  def initialize(animation)
  	@x = @y = @vel_x = @vel_y = @angle = 1.0
    @animation = animation
    @color = Gosu::Color.new(0xff000000)
    @color.red = rand(256 - 40) + 40
    @color.green = rand(256 - 40) + 40
    @color.blue = rand(256 - 40) + 40
    @x = rand(620)
    @y = rand(460)
    @des = "test"
  end

  def des
  	puts @des
  end

  def draw  
    img = @animation[Gosu::milliseconds / 100 % @animation.size];
    img.draw(@x - img.width / 2.0, @y - img.height / 2.0,
        ZOrder::Stars, 1, 1)
  end
end


class Bullet
  def initialize(window)
    @image = Gosu::Image.new(window, "lib/bullet.png", false)
    @x = @y = @vel_x = @vel_y = @angle = 90
    @score = 0
    @lives = 0
    @live2 = 40
    @amount = 20
  end

  def x
  	@x
  end

  def y
  	@y
  end

  def warp(x, y)
    @x, @y = x, y
  end
  
   def turn_left(speed)
    @x -= speed
  end
  
  def turn_right(speed)
    @x += speed
  end 

  def turn_down(speed)
  	@y += speed
  end

 def turn_up(speed)
  	@y -= speed
  end

  def amount
    @amount
  end

  def reset
  	@live2 = 40
  end

  def down
  	@score = 0
  end

  def jump
  	@y -= 35
  end

  def fall
    @y += 35
  end
  
  def shoot_right
  	@vel_x += Gosu::offset_x(@angle, 0.95)
  	@vel_y += Gosu::offset_y(@angle, 0.95)
  end

  def shoot_left
  	@vel_x -= Gosu::offset_x(@angle, 0.95)
  	@vel_y -= Gosu::offset_y(@angle, 0.95)
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= 10000000000000
    @y %= 10000000000000
    
    @vel_x *= 0.95
    @vel_y *= 0.95
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end
  def Score
    @score
  end

  def live2
  	@live2
  end

  def Lives
  	@lives
  end

  def button(amount)
    @amount += amount
  end

   def collect_player(enemy, explosion)
    if Gosu::distance(@x, @y, enemy.x, enemy.y) < 35
    	@live2 -= 0.75
      @explosions.push(Explosion.new(@explosion, enemy.x, enemy.y))
  end
end
def shot()
  @amount -= 1
end
end
end







window = GameWindow.new
window.show