require 'gtk3'
require 'cairo'

require './truck_lib/node.rb'
require './truck_lib/beam.rb'

require './truck_backend/events.rb'
include EVENT_FOR_STRUCTURE

module DRAW_STRUCTURE
	@view = 0

  	def show_loader(widget, canvas)
  		widget.signal_connect("activate") {
			|a|
			open_win = Gtk::FileChooserDialog.new(:title => "Load File", :action => :open, :buttons => [[Gtk::Stock::OPEN, :accept],[Gtk::Stock::CANCEL, :cancel]])
  			# Creates the configuration to load a truck file to the program.

			only_truck = Gtk::FileFilter.new()
			only_truck.name = "RoR Truck Files"
			only_truck.add_pattern("*.truck")
			open_win.add_filter(only_truck)
			# Creates the filter so other files without the extension ".truck" are excluded from the file chooser.
			
			if open_win.run == Gtk::ResponseType::ACCEPT then
				self.load_truck(open_win.filename(), canvas)
				canvas.queue_draw
			end
			# This will start the file handling after file is selected and accepted by the file chooser.
			
			open_win.destroy()
		}
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
  
	def load_truck(trk, canvas)
		i = 0
		trk = Truck.new(trk)
		# Initializes truck file to app


		@real_x = EVENT_FOR_STRUCTURE.centered_x(canvas) if EVENT_FOR_STRUCTURE.get_x(canvas) == 0
		@real_y = EVENT_FOR_STRUCTURE.centered_y(canvas) if EVENT_FOR_STRUCTURE.get_y(canvas) == 0
		
		load_nodes(trk)
    	load_beams(trk)

		canvas.signal_connect("draw") {
			|a, b|

				@size = EVENT_FOR_STRUCTURE.get_size(canvas)
  				# Initial size for the whole n/b structure
  				
  				@real_x = EVENT_FOR_STRUCTURE.get_x(canvas) if EVENT_FOR_STRUCTURE.get_x(canvas) != 0
				@real_y = EVENT_FOR_STRUCTURE.get_y(canvas) if EVENT_FOR_STRUCTURE.get_y(canvas) != 0
				

				b.set_source_rgb(1, 0.5, 0)
				# Sets default color to orange

				b.translate(@real_x, @real_y)
				b.rotate(3.145)
				# Helps move structure anywhere in the Drawing Area

				@truck_beam_x.length.times {
					|i|
					
					case @view
					  when 0
					    b.move_to(-@truck_beam_x[i][0] * @size, @truck_beam_y[i][0] * @size)
					    b.line_to(-@truck_beam_x[i][1] * @size, @truck_beam_y[i][1] * @size)
					    #Camera on front direction
					  when 1
					    b.move_to(@truck_beam_x[i][0] * @size, @truck_beam_y[i][0] * @size)
					    b.line_to(@truck_beam_x[i][1] * @size, @truck_beam_y[i][1] * @size)
					    #Camera on back direction
				 	  when 2
				    	b.move_to(@truck_beam_z[i][0] * @size, @truck_beam_y[i][0] * @size)
            			b.line_to(@truck_beam_z[i][1] * @size, @truck_beam_y[i][1] * @size)
            	    #Camera on left direction
	          		  when 3
			            b.move_to(-@truck_beam_z[i][0] * @size, @truck_beam_y[i][0] * @size)
			            b.line_to(-@truck_beam_z[i][1] * @size, @truck_beam_y[i][1] * @size)
			            #Camera on left direction
		          	  when 4
			            b.move_to(@truck_beam_x[i][0] * @size, @truck_beam_z[i][0] * @size)
			            b.line_to(@truck_beam_x[i][1] * @size, @truck_beam_z[i][1] * @size)
			            # Default top camera direction 
		          	  when 5
			            b.move_to(-@truck_beam_x[i][0] * @size, @truck_beam_z[i][0] * @size)
			            b.line_to(-@truck_beam_x[i][1] * @size, @truck_beam_z[i][1] * @size)
			            # Default bottom camera direction         
					  else
					    b.move_to(-@truck_beam_x[i][0] * @size, @truck_beam_y[i][0] * @size)
	            		b.line_to(-@truck_beam_x[i][1] * @size, @truck_beam_y[i][1] * @size)
          			end
          		}
          		# Sets the camera direction based on what's changed from the @view instance variable.

				b.stroke()
				# This loop draws out the beams

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