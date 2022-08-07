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
  @view = nil
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

  @hydro_src_matrix = []
  @hydro_dst_matrix = []
  # Organizes beam coords to its respective arrays
    
  def load_hydros(trk)
      i = 0
  	
  	  @hydro_src_matrix.clear()
  	  @hydro_dst_matrix.clear()

      while i != trk.view_hydros.length do
        truck_hydro_counter = Hydrolic.new(trk, i)

        @hydro_src_matrix[i] = Matrix[[truck_hydro_counter.show_source_x], [truck_hydro_counter.show_source_y], [truck_hydro_counter.show_source_z]]
        @hydro_dst_matrix[i] = Matrix[[truck_hydro_counter.show_dest_x], [truck_hydro_counter.show_dest_y], [truck_hydro_counter.show_dest_z]]

        i = i + 1
      end
      # This loop iterates through all node arguments for each hydraulic and places its respective coords in their array
  end

  @shock_src_matrix = []
  @shock_dst_matrix = []
  # Organizes beam coords to its respective arrays


  def load_shocks(trk)
      i = 0
  	
  	  @shock_src_matrix.clear()
  	  @shock_dst_matrix.clear()

      while i != trk.view_shocks.length do
        truck_shock_counter = Shock.new(trk, i)

        @shock_src_matrix[i] = Matrix[[truck_shock_counter.show_source_x], [truck_shock_counter.show_source_y], [truck_shock_counter.show_source_z]]
        @shock_dst_matrix[i] = Matrix[[truck_shock_counter.show_dest_x], [truck_shock_counter.show_dest_y], [truck_shock_counter.show_dest_z]]

        i = i + 1
      end
      # This loop iterates through all node arguments for each shock and places its respective coords in their array
  end
  
  @node_matrix = []
  # Similar to the beam arrays, puts its coords in these respective arrays
  
  def load_nodes(trk)
  
      i = 0

      @node_matrix.clear()

      while i != trk.view_nodes.length do
        truck_node_counter = Node.new(trk, i)
  
        @node_matrix[i] = Matrix[[truck_node_counter.show_x], [truck_node_counter.show_y], [truck_node_counter.show_z]]
  
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

        @node_matrix.length.times {
          |i|

          rotated_node_z = rot_z * @node_matrix[i]
          rotated_node_y = rot_y * rotated_node_z
          rotated_node = rot_x * rotated_node_y

          projected_2d = proj_mat * rotated_node

          b.rectangle(-projected_2d[0, 0] * @size, projected_2d[1, 0] * @size, 10, 10)
              
        }

        b.fill()

        b.set_source_rgba(0, 0, 0, 0.45)
        # Sets selected node color to transparent black

        rotated_snode_z = rot_z * Matrix[[@selected_node_x], [@selected_node_y], [@selected_node_z]]
        rotated_snode_y = rot_y * rotated_snode_z
        rotated_snode = rot_x * rotated_snode_y

        projected_2d = proj_mat * rotated_snode

        b.rectangle(-projected_2d[0, 0] * @size, projected_2d[1, 0] * @size, 10, 10)
        b.fill()

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

				b.set_source_rgb(0.5, 0.3, 0.5)
				b.set_line_width(5)

        # This loop draws out the beams
        # Adds the extra beams since it doesn't get visualized.

				@hydro_src_matrix.length.times {
					|i|

          rotated_src_hydro_z = rot_z * @hydro_src_matrix[i]
          rotated_src_hydro_y = rot_y * rotated_src_hydro_z
          rotated_src_hydro = rot_x * rotated_src_hydro_y

          rotated_dst_hydro_z = rot_z * @hydro_dst_matrix[i]
          rotated_dst_hydro_y = rot_y * rotated_dst_hydro_z
          rotated_dst_hydro = rot_x * rotated_dst_hydro_y

          @projected_src_2d = proj_mat * rotated_src_hydro
          @projected_dst_2d = proj_mat * rotated_dst_hydro

					load_beam_sketch(b, @projected_src_2d[0, 0], @projected_src_2d[1, 0], @projected_dst_2d[0, 0], @projected_dst_2d[1, 0], @size, true)
					load_beam_sketch(b, @projected_src_2d[0, 0], @projected_src_2d[1, 0], @projected_dst_2d[0, 0], @projected_dst_2d[1, 0], @size, true)
					load_beam_sketch(b, @projected_src_2d[0, 0], @projected_src_2d[1, 0], @projected_dst_2d[0, 0], @projected_dst_2d[1, 0], @size, true)
					load_beam_sketch(b, @projected_src_2d[0, 0], @projected_src_2d[1, 0], @projected_dst_2d[0, 0], @projected_dst_2d[1, 0], @size, true)
					load_beam_sketch(b, @projected_src_2d[0, 0], @projected_src_2d[1, 0], @projected_dst_2d[0, 0], @projected_dst_2d[1, 0], @size, true)
					load_beam_sketch(b, @projected_src_2d[0, 0], @projected_src_2d[1, 0], @projected_dst_2d[0, 0], @projected_dst_2d[1, 0], @size, true)

          # Sets the camera direction based on what's changed from the @view instance variable.
        }

        b.stroke()
        # This loop draws out the hydraulics.

        b.set_source_rgb(0.8, 0.8, 0.1)
				b.set_line_width(5)

				@shock_src_matrix.length.times {
					|i|

          rotated_src_shock_z = rot_z * @shock_src_matrix[i]
          rotated_src_shock_y = rot_y * rotated_src_shock_z
          rotated_src_shock = rot_x * rotated_src_shock_y

          rotated_dst_shock_z = rot_z * @shock_dst_matrix[i]
          rotated_dst_shock_y = rot_y * rotated_dst_shock_z
          rotated_dst_shock = rot_x * rotated_dst_shock_y

          @projected_src_2d = proj_mat * rotated_src_shock
          @projected_dst_2d = proj_mat * rotated_dst_shock


					load_beam_sketch(b, @projected_src_2d[0, 0], @projected_src_2d[1, 0], @projected_dst_2d[0, 0], @projected_dst_2d[1, 0], @size, true)
          load_beam_sketch(b, @projected_src_2d[0, 0], @projected_src_2d[1, 0], @projected_dst_2d[0, 0], @projected_dst_2d[1, 0], @size, true)
          load_beam_sketch(b, @projected_src_2d[0, 0], @projected_src_2d[1, 0], @projected_dst_2d[0, 0], @projected_dst_2d[1, 0], @size, true)
          load_beam_sketch(b, @projected_src_2d[0, 0], @projected_src_2d[1, 0], @projected_dst_2d[0, 0], @projected_dst_2d[1, 0], @size, true)
          load_beam_sketch(b, @projected_src_2d[0, 0], @projected_src_2d[1, 0], @projected_dst_2d[0, 0], @projected_dst_2d[1, 0], @size, true)
          load_beam_sketch(b, @projected_src_2d[0, 0], @projected_src_2d[1, 0], @projected_dst_2d[0, 0], @projected_dst_2d[1, 0], @size, true)
          # Sets the camera direction based on what's changed from the @view instance variable.

          b.stroke()
          		
				b.new_path()
			}
		}
	end

  def front_selection(widget, canvas) 
    widget.signal_connect("activate") {
      @view = 0
      canvas.queue_draw()
      @view = nil
    }
  end
  # Sets the camera direction to front using the menu selection's activate signal.

  def back_selection(widget, canvas)
    widget.signal_connect("activate") {
      @view = 1
      canvas.queue_draw()
      @view = nil
    }
  end
    # Sets the camera direction to back using the menu selection's activate signal.

  def right_selection(widget, canvas)
    widget.signal_connect("activate") {
      @view = 2
      canvas.queue_draw()
      @view = nil
    }
  end
  # Sets the camera direction to left using the menu selection's activate signal.

  def left_selection(widget, canvas)
    widget.signal_connect("activate") {
      @view = 3
      canvas.queue_draw()
      @view = nil
    }
  end
  # Sets the camera direction to right using the menu selection's activate signal.

  def top_selection(widget, canvas)
    widget.signal_connect("activate") {
      @view = 4
      canvas.queue_draw()
      @view = nil
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