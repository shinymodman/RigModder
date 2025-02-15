require 'gtk3'

module EVENT_FOR_STRUCTURE
	@click_result = nil
	@press_result = nil

	@real_x = 0
	@real_y = 0

	@real_ang_x = 0
	@real_ang_y = 0
	@real_ang_z = 0

	@cur_x = 0
	@cur_y = 0
	@cur_z = 0

	@prev_cur_x = 0
	@prev_cur_y = 0
	@prev_cur_z = 0

	@size = 250
	@size_for_flares = @size * 2

	@cosine = 0
	@prev_cosine = 0

	def click(widget, canvas)

		widget.signal_connect("button-press-event") {
			|a, b|
      		@click_result = Gdk::BUTTON_PRIMARY
      		canvas.queue_draw()
		}
		# The signal that will detect the left button press in order for the user to move the position of the structure.

		widget.signal_connect("button-release-event") {
			|a, b|
		  	@click_result = nil
		  	canvas.queue_draw()
		}
		# The signal that will detect the left button release in order for the user to confirm the position of the structure.

		widget.signal_connect("key-press-event") {
			|a, b|
			if b.keyval == Gdk::Keyval::KEY_Shift_L then
				@press_result = Gdk::Keyval::KEY_Shift_L
			elsif b.keyval == Gdk::Keyval::KEY_Control_L
				@press_result = Gdk::Keyval::KEY_Control_L
			elsif b.keyval == Gdk::Keyval::KEY_Alt_L
				@press_result = Gdk::Keyval::KEY_Alt_L
			elsif (b.keyval == Gdk::Keyval::KEY_s) then
				@cosine += 30
				puts @cosine
			end

			canvas.queue_draw()
		}

		widget.signal_connect("key-release-event") {
			@press_result = nil
		}
	end
	# The signal that will detect a left click

	def right_click(widget, canvas)

		widget.signal_connect("button-press-event") {
			|a, b|
      		@click_result = Gdk::BUTTON_SECONDARY
      		canvas.queue_draw()
		}
		# The signal that will detect the right button press in order for the user to move the position of the structure.

		widget.signal_connect("button-release-event") {
			|a, b|
		  	@click_result = nil
		  	@press_result = nil
		  	canvas.queue_draw()
		}
		# The signal that will detect the right button release in order for the user to confirm the position of the structure.
	end
	# The signal that will detect a right click

	def drag_or_rotate_struct(widget, canvas)

		widget.signal_connect("motion-notify-event") {
			|a, b|

			if (@press_result & Gdk::EventMask::BUTTON_PRESS_MASK.to_i)
				@cur_x = b.x
				@cur_y = b.y
				@cur_z = b.x
			end

			if (@press_result & Gdk::EventMask::BUTTON_MOTION_MASK.to_i) then

				if (@cur_x < @prev_cur_x) then
					@prev_cur_x = 0
					@real_ang_x += 0.02 if @press_result == Gdk::Keyval::KEY_Shift_L
				else
					@prev_cur_x = 0
					@real_ang_x -= 0.02 if @press_result == Gdk::Keyval::KEY_Shift_L
				end

			  	if (@cur_y < @prev_cur_y) then
			  		@prev_cur_y = 0
			  		@real_ang_y += 0.02 if @press_result == Gdk::Keyval::KEY_Control_L
			  	else
			  		@prev_cur_y = 0
			  		@real_ang_y -= 0.02 if @press_result == Gdk::Keyval::KEY_Control_L
			  	end

			  	if (@cur_z < @prev_cur_z) then
			  		@prev_cur_z = 0
			  		@real_ang_z += 0.02 if @press_result == Gdk::Keyval::KEY_Alt_L
			  	else
			  		@prev_cur_z = 0
			  		@real_ang_z -= 0.02 if @press_result == Gdk::Keyval::KEY_Alt_L
			  	end
			end

			if (@press_result & Gdk::EventMask::BUTTON_RELEASE_MASK.to_i) then
				@prev_cur_x = @cur_x
				@prev_cur_y = @cur_y
				@prev_cur_z = @cur_z
			end

			if (@click_result & Gdk::EventMask::BUTTON_PRESS_MASK.to_i)
		      	@real_x = b.x if @press_result == nil
		      	@real_y = b.y if @press_result == nil
		  	end

		  	canvas.queue_draw()
		  	# The signal that will detect a right click hold in order for the user to rotate the structure to a different angle of the interface.

		}

	end

	def zoom_in_or_out(widget, canvas)
		widget.add_events(Gdk::EventMask::SCROLL_MASK)
		widget.signal_connect("scroll-event") {
			|a, b|
			if (b.direction == Gdk::ScrollDirection::UP)
		  	  @size += 10
		  	  @size_for_flares += 10
		  	  canvas.queue_draw()
		  	  # Shrinks structure
		  	elsif (b.direction == Gdk::ScrollDirection::DOWN)
		  	  @size -= 10
		  	  @size_for_flares -= 10
		  	  canvas.queue_draw()
		  	  # Grows structure
		  	end
		}
		# The signal is for zooming in/out the Truck structure.
	end

	def get_size(canvas)
		return @size
	end
	# Returns size value of structure.

	def get_size_for_flares()
		return @size / 3.05
	end
	# Returns size value of structure.

	def get_x(canvas)
		return @real_x
		canvas.queue_draw()
	end
	# Returns x value of cursor

	def get_y(canvas)
		return @real_y
		canvas.queue_draw()
	end
	# Returns y value of cursor.

	def get_ang_x(canvas)
		return @real_ang_x
		canvas.queue_draw()
	end
	# Returns x angled value of cursor

	def get_ang_y(canvas)
		return @real_ang_y
		canvas.queue_draw()
	end
	# Returns y angled value of cursor.

	def get_ang_z(canvas)
		return @real_ang_z
		canvas.queue_draw()
	end
	# Returns y angled value of cursor.

	def centered_x(canvas)
		return canvas.allocated_width / 2
		canvas.queue_draw
	end
	# Returns the x coord that centers the whole structure

	def centered_y(canvas)
		return canvas.allocated_height / 2
		canvas.queue_draw
	end
	# Returns the y coord that centers the whole structure

	def get_cosine(canvas)
		return @cosine
		canvas.queue_draw
	end

	def load_dialog(widget, window, height, width, *inner_widgets)
    	widget.signal_connect("activate") {
      	  window.set_default_size(height, width)

      	  inner_widgets.each {
      	  	|i|
      	  	window.add(i) if (window.each_all.count < inner_widgets.count)
      	  }
      	  
      	  window.show_all()
    	}

    	window.signal_connect("delete-event") {
    		|a|

    		a.hide()
    	}
    end
    # Shows a dialog using the menu selection's activate signal.
end