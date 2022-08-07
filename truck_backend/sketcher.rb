require 'gtk3'
require 'cairo'
require 'matrix'

require './truck_lib/node.rb'
require './truck_lib/beam.rb'
require './truck_lib/hydrolic.rb'
require './truck_lib/shock.rb'

require './truck_backend/events.rb'
include EVENT_FOR_STRUCTURE

module DRAW_STRUCTURE
  @view = 0
  @selection = 0
  @node_selector_obj = nil

  def show_loader(filename, canvas)
	self.load_truck(filename, canvas) if !(filename.empty?)
	canvas.queue_draw
  end

  @beam_src_matrix = []
  @beam_dst_matrix = []
  # Organizes beam coords to its respective arrays
    
  def load_beams(trk)
      i = 0
  	
  	  @beam_src_matrix.clear()
  	  @beam_dst_matrix.clear()

      while i != trk.view_beams.length do
        truck_beam_counter = Beam.new(trk, i)

        @beam_src_matrix[i] = Matrix[[truck_beam_counter.show_source_x], [truck_beam_counter.show_source_y], [truck_beam_counter.show_source_z]]
        @beam_dst_matrix[i] = Matrix[[truck_beam_counter.show_dest_x], [truck_beam_counter.show_dest_y], [truck_beam_counter.show_dest_z]]

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

  @selected_node_x = 0
  @selected_node_y = 0
  @selected_node_z = 0
  # Similar to the beam arrays, puts its coords in these respective arrays

	def load_beam_sketch(context, sketch_x, sketch_y, dest_x, dest_y, size, line_to_enabled)
	   context.move_to(-sketch_x * size, sketch_y * size)
	   context.line_to(-dest_x * size, dest_y * size) if line_to_enabled == true
	end

	def set_node_selector(widget)
		@node_selector_obj = widget
	end
	# Placeholder for different files

	def load_truck(trk, canvas)
		i = 0
		trk = Truck.new(trk)
		# Initializes truck file to app

		@real_x = EVENT_FOR_STRUCTURE.centered_x(canvas) if EVENT_FOR_STRUCTURE.get_x(canvas) == 0
		@real_y = EVENT_FOR_STRUCTURE.centered_y(canvas) if EVENT_FOR_STRUCTURE.get_y(canvas) == 0
		# variables that center the sketch.

		
		@angX = EVENT_FOR_STRUCTURE.get_ang_x(canvas)
		@angY = EVENT_FOR_STRUCTURE.get_ang_y(canvas)
		@angZ = EVENT_FOR_STRUCTURE.get_ang_z(canvas)
		# Angle rotations for each coordinate

		load_nodes(trk)
    	load_beams(trk)
    	load_hydros(trk)
    	load_shocks(trk)
    	# Loads all content into DrawingArea widget (or sketch of truck file).

    	@node_selector_obj.signal_connect("row-activated") {
  			|a, b|
  			node_selector = Node.new(trk, b.index)

    		@selected_node_x = node_selector.show_x
    		@selected_node_y = node_selector.show_y
    		@selected_node_z = node_selector.show_z
  			canvas.queue_draw()
  		}
  		# The Gtk signal that sets up the node selected by a user interacting with the Node listbox.

		canvas.signal_connect("draw") {
			|a, b|

				b.new_path()

				@size = EVENT_FOR_STRUCTURE.get_size(canvas)
  				# Initial size for the whole n/b structure
  				
  				@real_x = EVENT_FOR_STRUCTURE.get_x(canvas) if EVENT_FOR_STRUCTURE.get_x(canvas) != 0
				@real_y = EVENT_FOR_STRUCTURE.get_y(canvas) if EVENT_FOR_STRUCTURE.get_y(canvas) != 0
				
				proj_mat = Matrix[[1, 0 ,0], [0, 1, 0]]
				# Projection matrix for all coordinates

				@angX = EVENT_FOR_STRUCTURE.get_ang_x(canvas)
				@angY = EVENT_FOR_STRUCTURE.get_ang_y(canvas)
				@angZ = EVENT_FOR_STRUCTURE.get_ang_z(canvas)
				# Angle rotations for each coordinate

				rot_x = Matrix[
					[1, 0, 0],
					[0, Math.cos(@angX), -Math.sin(@angX)],
					[0, Math.sin(@angX), Math.cos(@angX)]
				]

				rot_y = Matrix[
					[Math.cos(@angY), 0, Math.sin(@angY)],
					[0, 1, 0],
					[-Math.sin(@angY), 0, Math.cos(@angY)]
				]

				rot_z = Matrix[
					[Math.cos(@angZ), -Math.sin(@angZ), 0],
					[Math.sin(@angZ), Math.cos(@angZ), 0],
					[0, 0, 1]
				]		

				# Rotation matrices for each coordinates

				b.translate(@real_x, @real_y)
				b.rotate(3.145)
				# Helps move structure anywhere in the Drawing Area

				b.set_source_rgba(0, 0.5, 0, 0.45)
				# Sets default color to a dark shade of green for the nodes

				b.set_source_rgb(1, 0.5, 0)
				# Sets default color to orange

				@beam_src_matrix.length.times {
					|i|

					rotated_src_beam_z = rot_z * @beam_src_matrix[i]
					rotated_src_beam_y = rot_y * rotated_src_beam_z
					rotated_src_beam = rot_x * rotated_src_beam_y

					rotated_dst_beam_z = rot_z * @beam_dst_matrix[i]
					rotated_dst_beam_y = rot_y * rotated_dst_beam_z
					rotated_dst_beam = rot_x * rotated_dst_beam_y

					@projected_src_2d = proj_mat * rotated_src_beam
					@projected_dst_2d = proj_mat * rotated_dst_beam

					load_beam_sketch(b, @projected_src_2d[0, 0], @projected_src_2d[1, 0], @projected_dst_2d[0, 0], @projected_dst_2d[1, 0], @size, true)
					load_beam_sketch(b, @projected_src_2d[0, 0], @projected_src_2d[1, 0], @projected_dst_2d[0, 0], @projected_dst_2d[1, 0], @size, true)
          		}

				b.stroke()
				# This loop draws out the beams
          		# Adds the extra beams since it doesn't get visualized.
=begin
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
=end
		}
		end


end