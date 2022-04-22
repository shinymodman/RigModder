require 'gtk3'
require 'cairo'

require './truck_lib/node.rb'
require './truck_lib/beam.rb'
require './truck_lib/hydrolic.rb'
require './truck_lib/shock.rb'

=begin

=end

require './truck_backend/events.rb'
include EVENT_FOR_STRUCTURE

module DRAW_STRUCTURE
	@view = 0

  	def show_loader(filename, canvas)
		self.load_truck(filename, canvas) if !(filename.empty?)
		canvas.queue_draw
  	end

  @truck_beam_x = []
  @truck_beam_y = []
  @truck_beam_z = []
  # Organizes beam coords to its respective arrays
    
  def load_beams(trk)
      i = 0
  	
  	  @truck_beam_x.clear()
  	  @truck_beam_y.clear()
  	  @truck_beam_z.clear()

      while i != trk.view_beams.length do
        truck_beam_counter = Beam.new(trk, i)
  
        @truck_beam_x[i] = [truck_beam_counter.show_source_x, truck_beam_counter.show_dest_x]
        @truck_beam_y[i] = [truck_beam_counter.show_source_y, truck_beam_counter.show_dest_y]
        @truck_beam_z[i] = [truck_beam_counter.show_source_z, truck_beam_counter.show_dest_z]

        i = i + 1
      end
      # This loop iterates through all node arguments for each beam and places its respective coords in their array
  end

  @truck_hydro_x = []
  @truck_hydro_y = []
  @truck_hydro_z = []
  # Organizes beam coords to its respective arrays
    
  def load_hydros(trk)
      i = 0
  	
  	  @truck_hydro_x.clear()
  	  @truck_hydro_y.clear()
  	  @truck_hydro_z.clear()

      while i != trk.view_hydros.length do
        truck_hydro_counter = Hydrolic.new(trk, i)

        @truck_hydro_x[i] = [truck_hydro_counter.show_source_x, truck_hydro_counter.show_dest_x]
        @truck_hydro_y[i] = [truck_hydro_counter.show_source_y, truck_hydro_counter.show_dest_y]
        @truck_hydro_z[i] = [truck_hydro_counter.show_source_z, truck_hydro_counter.show_dest_z]

        i = i + 1
      end
      # This loop iterates through all node arguments for each hydraulic and places its respective coords in their array
  end

  @truck_shock_x = []
  @truck_shock_y = []
  @truck_shock_z = []
  # Organizes beam coords to its respective arrays


  def load_shocks(trk)
      i = 0
  	
  	  @truck_shock_x.clear()
  	  @truck_shock_y.clear()
  	  @truck_shock_z.clear()

      while i != trk.view_shocks.length do
        truck_shock_counter = Shock.new(trk, i)

        @truck_shock_x[i] = [truck_shock_counter.show_source_x, truck_shock_counter.show_dest_x]
        @truck_shock_y[i] = [truck_shock_counter.show_source_y, truck_shock_counter.show_dest_y]
        @truck_shock_z[i] = [truck_shock_counter.show_source_z, truck_shock_counter.show_dest_z]

        i = i + 1
      end
      # This loop iterates through all node arguments for each shock and places its respective coords in their array
  end
  
  @truck_node_x = []
  @truck_node_y = []
  @truck_node_z = []
  # Similar to the beam arrays, puts its coords in these respective arrays
  
  def load_nodes(trk)
  
      i = 0

      @truck_node_x.clear()
  	  @truck_node_y.clear()
  	  @truck_node_z.clear()
  
      while i != trk.view_nodes.length do
        truck_node_counter = Node.new(trk, i)
  
        @truck_node_x[i] = truck_node_counter.show_x
        @truck_node_y[i] = truck_node_counter.show_y
        @truck_node_z[i] = truck_node_counter.show_z
  
        i = i + 1
      end
      # Iterates through each node and puts its coords to its respective arrays
  end

	def load_beam_sketch(context, sketch_x, sketch_y, dest_x, dest_y, size, angle, line_to_enabled)

		case angle
		  when 0
		    context.move_to(-sketch_x * size, sketch_y * size)
		    context.line_to(-dest_x * size, dest_y * size) if line_to_enabled == true
		    #Camera on front direction
		  when 1
            context.move_to(sketch_x * size, sketch_y * size)
            context.line_to(dest_x * size, dest_y * size) if line_to_enabled == true
		    #Camera on back direction
	 	  when 2
            context.move_to(sketch_x * size, sketch_y * size)
            context.line_to(dest_x * size, dest_y * size) if line_to_enabled == true
	    #Camera on left direction
  		  when 3
		    context.move_to(-sketch_x * size, sketch_y * size)
		    context.line_to(-dest_x * size, dest_y * size) if line_to_enabled == true
            #Camera on left direction
      	  when 4
            context.move_to(sketch_x * size, sketch_y * size)
            context.line_to(dest_x * size, dest_y * size) if line_to_enabled == true
            # Default top camera direction 
      	  when 5
		    context.move_to(-sketch_x * size, sketch_y * size)
		    context.line_to(-dest_x * size, dest_y * size) if line_to_enabled == true
            # Default bottom camera direction         
		  else
		    context.move_to(-sketch_x * size, sketch_y * size)
		    context.line_to(-dest_x * size, dest_y * size) if line_to_enabled == true
		end
	end
	# Wrapper for line creation in cairo w/ line_to (on/off) switch
	# ^^
	# On if true
	# Off if false

	def load_truck(trk, canvas)
		i = 0
		trk = Truck.new(trk)
		# Initializes truck file to app

		@real_x = EVENT_FOR_STRUCTURE.centered_x(canvas) if EVENT_FOR_STRUCTURE.get_x(canvas) == 0
		@real_y = EVENT_FOR_STRUCTURE.centered_y(canvas) if EVENT_FOR_STRUCTURE.get_y(canvas) == 0
		
		load_nodes(trk)
    	load_beams(trk)
    	load_hydros(trk)
    	load_shocks(trk)

		canvas.signal_connect("draw") {
			|a, b|

				b.new_path()

				@size = EVENT_FOR_STRUCTURE.get_size(canvas)
  				# Initial size for the whole n/b structure
  				
  				@real_x = EVENT_FOR_STRUCTURE.get_x(canvas) if EVENT_FOR_STRUCTURE.get_x(canvas) != 0
				@real_y = EVENT_FOR_STRUCTURE.get_y(canvas) if EVENT_FOR_STRUCTURE.get_y(canvas) != 0
				

				b.translate(@real_x, @real_y)
				b.rotate(3.145)
				# Helps move structure anywhere in the Drawing Area

				b.set_source_rgba(0, 0.5, 0, 0.45)
				# Sets default color to a dark shade of green for the nodes


				@truck_node_x.length.times {
					|i|
		          	case @view
		           	when 0
			            b.rectangle(-@truck_node_x[i] * @size, @truck_node_y[i] * @size, 10, 10)
			            # Default front camera direction
		           	when 1
		             	b.rectangle(@truck_node_x[i] * @size, @truck_node_y[i] * @size, 10, 10)
		             	# Default back camera direction
		           	when 2
		             	b.rectangle(@truck_node_z[i] * @size, @truck_node_y[i] * @size, 10, 10)
		             	# Default right camera direction
		           	when 3
		             	b.rectangle(-@truck_node_z[i] * @size, @truck_node_y[i] * @size, 10, 10)
		             	# Default left camera direction
		           	when 4
		             	b.rectangle(@truck_node_x[i] * @size, @truck_node_z[i] * @size, 10, 10)
		             	# Default top camera direction 
		           	when 5
		             	b.rectangle(-@truck_node_x[i] * @size, @truck_node_z[i] * @size, 10, 10)
		             	# Default bottom camera direction         
		           	else
		             	b.rectangle(-@truck_node_x[i] * @size, @truck_node_y[i] * @size, 10, 10)
		             	# Default camera direction
		           	end
							
				}

				b.fill()
				# This loop places the nodes to its respective areas

				b.set_source_rgb(1, 0.5, 0)
				# Sets default color to orange

				@truck_beam_x.length.times {
					|i|
					load_beam_sketch(b, @truck_beam_x[i][0], @truck_beam_y[i][0], @truck_beam_x[i][1], @truck_beam_y[i][1], @size, 0, true) if @view == 0
					load_beam_sketch(b, @truck_beam_x[i][0], @truck_beam_y[i][0], @truck_beam_x[i][1], @truck_beam_y[i][1], @size, 1, true) if @view == 1
					load_beam_sketch(b, @truck_beam_z[i][0], @truck_beam_y[i][0], @truck_beam_z[i][1], @truck_beam_y[i][1], @size, 2, true) if @view == 2
					load_beam_sketch(b, @truck_beam_z[i][0], @truck_beam_y[i][0], @truck_beam_z[i][1], @truck_beam_y[i][1], @size, 3, true) if @view == 3
					load_beam_sketch(b, @truck_beam_x[i][0], @truck_beam_z[i][0], @truck_beam_x[i][1], @truck_beam_z[i][1], @size, 4, true) if @view == 4
					load_beam_sketch(b, @truck_beam_x[i][0], @truck_beam_z[i][0], @truck_beam_x[i][1], @truck_beam_z[i][1], @size, 5, true) if @view == 5
          		}
          		# Sets the camera direction based on what's changed from the @view instance variable.

				b.stroke()
				# This loop draws out the beams


          		# Adds the extra beams since it doesn't get visualized.

				b.set_source_rgb(0.5, 0.3, 0.5)
				b.set_line_width(5)

				@truck_hydro_x.length.times {
					|i|
					load_beam_sketch(b, @truck_hydro_x[i][0], @truck_hydro_y[i][0], @truck_hydro_x[i][1], @truck_hydro_y[i][1], @size, 0, true) if @view == 0
					load_beam_sketch(b, @truck_hydro_x[i][0], @truck_hydro_y[i][0], @truck_hydro_x[i][1], @truck_hydro_y[i][1], @size, 1, true) if @view == 1
					load_beam_sketch(b, @truck_hydro_z[i][0], @truck_hydro_y[i][0], @truck_hydro_z[i][1], @truck_hydro_y[i][1], @size, 2, true) if @view == 2
					load_beam_sketch(b, @truck_hydro_z[i][0], @truck_hydro_y[i][0], @truck_hydro_z[i][1], @truck_hydro_y[i][1], @size, 3, true) if @view == 3
					load_beam_sketch(b, @truck_hydro_x[i][0], @truck_hydro_z[i][0], @truck_hydro_x[i][1], @truck_hydro_z[i][1], @size, 4, true) if @view == 4
					load_beam_sketch(b, @truck_hydro_x[i][0], @truck_hydro_z[i][0], @truck_hydro_x[i][1], @truck_hydro_z[i][1], @size, 5, true) if @view == 5

          		# Sets the camera direction based on what's changed from the @view instance variable.
          		}

          		b.stroke()
          		# This loop draws out the hydraulics.
          		b.set_source_rgb(0.8, 0.8, 0.1)
				b.set_line_width(5)

				@truck_shock_x.length.times {
					|i|
					load_beam_sketch(b, @truck_shock_x[i][0], @truck_shock_y[i][0], @truck_shock_x[i][1], @truck_shock_y[i][1], @size, 0, true) if @view == 0
					load_beam_sketch(b, @truck_shock_x[i][0], @truck_shock_y[i][0], @truck_shock_x[i][1], @truck_shock_y[i][1], @size, 1, true) if @view == 1
					load_beam_sketch(b, @truck_shock_z[i][0], @truck_shock_y[i][0], @truck_shock_z[i][1], @truck_shock_y[i][1], @size, 2, true) if @view == 2
					load_beam_sketch(b, @truck_shock_z[i][0], @truck_shock_y[i][0], @truck_shock_z[i][1], @truck_shock_y[i][1], @size, 3, true) if @view == 3
					load_beam_sketch(b, @truck_shock_x[i][0], @truck_shock_z[i][0], @truck_shock_x[i][1], @truck_shock_z[i][1], @size, 4, true) if @view == 4
					load_beam_sketch(b, @truck_shock_x[i][0], @truck_shock_z[i][0], @truck_shock_x[i][1], @truck_shock_z[i][1], @size, 5, true) if @view == 5

          		# Sets the camera direction based on what's changed from the @view instance variable.
          		}

          		b.stroke()
          		
				b.new_path()
			}
		end

		def front_selection(widget, canvas) 
			widget.signal_connect("activate") {
			  @view = 0
			  canvas.queue_draw()
			}
		end
		# Sets the camera direction to front using the menu selection's activate signal.

		def back_selection(widget, canvas)
			widget.signal_connect("activate") {
			  @view = 1
			  canvas.queue_draw()
			}
		end
	    # Sets the camera direction to back using the menu selection's activate signal.
		
		def right_selection(widget, canvas)
		    widget.signal_connect("activate") {
		      @view = 2
		      canvas.queue_draw()
		    }
		end
		# Sets the camera direction to left using the menu selection's activate signal.

		def left_selection(widget, canvas)
		    widget.signal_connect("activate") {
		      @view = 3
		      canvas.queue_draw()
		    }
		end
		# Sets the camera direction to right using the menu selection's activate signal.

		def top_selection(widget, canvas)
		    widget.signal_connect("activate") {
		      @view = 4
		      canvas.queue_draw()
		    }
	    end
	    # Sets the camera direction to top using the menu selection's activate signal.
	    
	    def bottom_selection(widget, canvas)
	    	widget.signal_connect("activate") {
	      	  @view = 5
	      	  canvas.queue_draw()
	    	}
	    end
	    # Sets the camera direction to bottom using the menu selection's activate signal.
end