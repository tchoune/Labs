class Character
	attr_accessor :x
	attr_accessor :y
	attr_accessor :z
	attr_accessor :direccion
	attr_reader :solid
	def initialize(window, x, y, filename, movement=:static, face=:down, solid=true, route='', commands='')
		@window = window
		@x = (x*32)
		@y = (y*32)-24
		@z = 2
		@movement_type = movement
		@face = face
		@poses = Image.load_tiles(window, "graphics/charasets/"+filename+".png", 32, 48, false)
		@pose = @poses[0]
		@direccion = :down
		@solid = solid
		@route = route
		@commands = commands
		@speed = 2
		@step = 15
	end
	def walk
		case @direccion
			when :up
				for i in 0...@speed
					@y -= 1 if not @window.scene.solid_event_infront?(self)
				end
			when :down
				for i in 0...@speed
					@y += 1 if not @window.scene.solid_event_infront?(self)
				end
			when :left
				for i in 0...@speed
					@x -= 1 if not @window.scene.solid_event_infront?(self)
				end
			when :right
				for i in 0...@speed
					@x += 1 if not @window.scene.solid_event_infront?(self)
				end
		end
		@step+=1
		return [@x, @y]
	end
	
	def face
		case @movement_type
			when :static
				case @face
					when :left
						@pose = @poses[4]
					when :right
						@pose = @poses[8]
					when :up
						@pose = @poses[12]
					when :down
						@pose = @poses[0]
				end
			
			when :random
				direccion = rand(4)
				case direccion
					when 0
					@direccion = :left
					when 1
					@direccion = :right
					when 2
					@direccion = :up
					when 3
					@direccion = :down
				end
		end
	end
	
	def draw
		if @direccion == :left
			if milliseconds / 175 % 4 == 0
				@pose = @poses[4]
			elsif milliseconds / 175 % 4 == 1
				@pose = @poses[5]
			elsif milliseconds / 175 % 4 == 2
				@pose = @poses[6]
			elsif milliseconds / 175 % 4 == 3
				@pose = @poses[7]
			end
		elsif @direccion == :right
			if milliseconds / 175 % 4 == 0
				@pose = @poses[8]
			elsif milliseconds / 175 % 4 == 1
				@pose = @poses[9]
			elsif milliseconds / 175 % 4 == 2
				@pose = @poses[10]
			elsif milliseconds / 175 % 4 == 3
				@pose = @poses[11]
			end
		elsif @direccion == :up
			if milliseconds / 175 % 4 == 0
				@pose = @poses[12]
			elsif milliseconds / 175 % 4 == 1
				@pose = @poses[13]
			elsif milliseconds / 175 % 4 == 2
				@pose = @poses[14]
			elsif milliseconds / 175 % 4 == 3
				@pose = @poses[15]
			end
		elsif @direccion == :down
			if milliseconds / 175 % 4 == 0
				@pose = @poses[0]
			elsif milliseconds / 175 % 4 == 1
				@pose = @poses[1]
			elsif milliseconds / 175 % 4 == 2
				@pose = @poses[2]
			elsif milliseconds / 175 % 4 == 3
				@pose = @poses[3]
			end
		end
		@pose.draw(@x - @window.scene.screen_x,@y - @window.scene.screen_y, @z)
	end
  
	def update
		@x_pies = @x + (@pose.width/2)
		@y_pies = @y + @pose.height
		if @step >= 15
			face
			@step = 0
		end
			if @direccion == :left and not @window.scene.mapa.solid(@x_pies-16, @y_pies) and @x > 0 - @window.scene.screen_x and not @window.scene.solid_event_infront?(self)
				walk
			elsif @direccion == :left and @window.scene.mapa.solid(@x_pies-16, @y_pies)  or @window.scene.solid_event_infront?(self)
				face
			elsif @direccion == :left and @x <= 0 - @window.scene.screen_x
				face
			end
			if @direccion == :right and not @window.scene.mapa.solid(@x_pies+16, @y_pies) and @x < (@window.scene.mapa.width * 32) - @pose.width and not @window.scene.solid_event_infront?(self)
				walk
			elsif @direccion == :right and @window.scene.mapa.solid(@x_pies+16, @y_pies)   or @window.scene.solid_event_infront?(self)
				face
			elsif @direccion == :right  and @x >= (@window.scene.mapa.width * 32) - @pose.width
				face
			end
			if @direccion == :up and not @window.scene.mapa.solid(@x_pies, @y_pies-16) and @y > 0 - @window.scene.screen_y and not @window.scene.solid_event_infront?(self)
				walk
			elsif @direccion == :up and @window.scene.mapa.solid(@x_pies, @y_pies-16)  or @window.scene.solid_event_infront?(self)
				face
			elsif @direccion == :up and @y <= 0 - @window.scene.screen_y
				face
			end
			if @direccion == :down and not @window.scene.mapa.solid(@x_pies, @y_pies+6) and @y < (@window.scene.mapa.height * 32) - @pose.height and not @window.scene.solid_event_infront?(self)
				walk
			elsif @direccion == :down and @window.scene.mapa.solid(@x_pies, @y_pies+6)  or @window.scene.solid_event_infront?(self)
				face
			elsif @direccion == :down and @y >= (@window.scene.mapa.height * 32) - @pose.height
				face
			end
			case @direccion
				when :left
					@pose = @poses[4]
				when :right
					@pose = @poses[8]
				when :up
					@pose = @poses[12]
				when :down
					@pose = @poses[0]
			end
			if @x > @window.scene.screen_x - 32 and @x < @window.scene.screen_x + 640 and @y > @window.scene.screen_y - 32 and @y < @window.scene.screen_y + 480
				self.draw
			end
	end
end