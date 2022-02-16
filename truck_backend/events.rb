require 'gtk3'

module EVENT_FOR_STRUCTURE
	@click_result = nil
	@real_x = 0
	@real_y = 0
	@size = 250

	def click(widget, canvas)

		widget.signal_connect("button-press-event") {
			|a, b|
      		@click_result = Gdk::BUTTON_PRIMARY
      		canvas.queue_draw()
		}

		widget.signal_connect("button-release-event") {
			|a, b|
		  	@click_result = nil
		  	canvas.queue_draw()
		}
		# The signal that will detect the left button release in order for the user to confirm the position of the structure.
	end
	# The signal that will detect a left click

	def drag_struct(widget, canvas)

		widget.signal_connect("motion-notify-event") {
		  |a, b|
		  
		  if (@click_result & Gdk::EventMask::BUTTON_PRESS_MASK.to_i)
		      @real_x = b.x
		      @real_y = b.y
		      canvas.queue_draw()
		  end
		}

		# The signal that will detect a left click hold in order for the user to drag the structure to a different position of the interface.
	end

	def zoom_in_or_out(widget, canvas)
		widget.add_events(Gdk::EventMask::SCROLL_MASK)
		widget.signal_connect("scroll-event") {
			|a, b|
			if (b.direction == Gdk::ScrollDirection::UP)
		  	  @size += 10
		  	  canvas.queue_draw()
		  	  # Shrinks structure
		  	elsif (b.direction == Gdk::ScrollDirection::DOWN)
		  	  @size -= 10
		  	  canvas.queue_draw()
		  	  # Grows structure
		  	end
		}
		# The signal is for zooming in/out the Truck structure.
	end

	def get_size(canvas)
		return @size
	end

	def get_x(canvas)
		return @real_x
		canvas.queue_draw()
	end

	def get_y(canvas)
		return @real_y
		canvas.queue_draw()
	end
end