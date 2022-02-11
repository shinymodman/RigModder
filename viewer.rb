require 'gtk3'
require 'cairo'
require 'matrix'

require './truck_lib/node'
require './truck_lib/beam'

class RigModder < Gtk::Window

  @view = 0
  
	def load_truck(trk)
		i = 0
		trk = Truck.new(trk)
		# Initializes truck file to app

		truck_beam_x = []
		truck_beam_y = []
		truck_beam_z = []
		# Organizes beam coords to its respective arrays

		while i != trk.view_beams.length do
			truck_beam_counter = Beam.new(trk, i)

			truck_beam_x[i] = [truck_beam_counter.show_source_x, truck_beam_counter.show_dest_x]
			truck_beam_y[i] = [truck_beam_counter.show_source_y, truck_beam_counter.show_dest_y]
			truck_beam_z[i] = [truck_beam_counter.show_source_z, truck_beam_counter.show_dest_z]

			i = i + 1
		end
		# This loop iterates through all node arguments for each beam and places its respective coords in their array

		truck_node_x = []
		truck_node_y = []
		truck_node_z = []
		# Similar to the beam arrays, puts its coords in these respective arrays

		i = 0

		while i != trk.view_nodes.length do
			truck_node_counter = Node.new(trk, i)

			truck_node_x[i] = truck_node_counter.show_x
			truck_node_y[i] = truck_node_counter.show_y
			truck_node_z[i] = truck_node_counter.show_z

			i = i + 1
		end
		# Iterates through each node and puts its coords to its respective arrays

  	@size = 50
  	# Initial size for the whole n/b structure

		@canvas.signal_connect("draw") {
			|a, b|
				b.set_source_rgb(1, 0.5, 0)
				# Sets default color to orange

				# This matrix will flip structure in order for it to display correctly

				b.translate(@real_x, @real_y)
				b.rotate(3.145)
				# Helps move structure anywhere in the Drawing Area

				truck_beam_x.length.times {
					|i|
					
					case @view
				  when 0
				    b.move_to(-truck_beam_x[i][0] * @size, truck_beam_y[i][0] * @size)
				    b.line_to(-truck_beam_x[i][1] * @size, truck_beam_y[i][1] * @size)
				    #Camera on front angle
				  when 1
				    b.move_to(truck_beam_x[i][0] * @size, truck_beam_y[i][0] * @size)
				    b.line_to(truck_beam_x[i][1] * @size, truck_beam_y[i][1] * @size)
				    #Camera on back angle
				  when 2
				    b.move_to(truck_beam_z[i][0] * @size, truck_beam_y[i][0] * @size)
            b.line_to(truck_beam_z[i][1] * @size, truck_beam_y[i][1] * @size)
            #Camera on left angle
          when 3
            b.move_to(-truck_beam_z[i][0] * @size, truck_beam_y[i][0] * @size)
            b.line_to(-truck_beam_z[i][1] * @size, truck_beam_y[i][1] * @size)
            #Camera on left angle
				  else
				    b.move_to(-truck_beam_x[i][0] * @size, truck_beam_y[i][0] * @size)
            b.line_to(-truck_beam_x[i][1] * @size, truck_beam_y[i][1] * @size)
          end
				}
				b.stroke()
				# This loop draws out the beams

				b.set_source_rgba(0, 0.5, 0, 0.45)
				# Sets default color to a dark shade of green for the nodes

				truck_node_x.length.times {
					|i|
          case @view
           when 0
             b.rectangle(-truck_node_x[i] * @size, truck_node_y[i] * @size, 10, 10)
           when 1
             b.rectangle(truck_node_x[i] * @size, truck_node_y[i] * @size, 10, 10)
           when 2
             b.rectangle(truck_node_z[i] * @size, truck_node_y[i] * @size, 10, 10)
           when 3
             b.rectangle(-truck_node_z[i] * @size, truck_node_y[i] * @size, 10, 10)            
           else
             b.rectangle(-truck_node_x[i] * @size, truck_node_y[i] * @size, 10, 10)
           end
					
				}
				b.fill()
				# This loop places the nodes to its respective areas
			}
	end

	def initialize
		super("RigModder")
		self.set_default_size(1080, 720)

		@grid = Gtk::Box.new(:vertical)
		# Declares grid object for holding a couple of gtk widgets

		@menu = Gtk::MenuBar.new()

		@file_menu = Gtk::Menu.new()
		@file_sel = Gtk::MenuItem.new(:label => "File")
		@file_sel.set_submenu(@file_menu)
		@menu.append(@file_sel)

		@open_item = Gtk::MenuItem.new(:label => "Open")
		@file_menu.append(@open_item)
		
		@view_menu = Gtk::Menu.new()
		@view_sel = Gtk::MenuItem.new(:label => "View")
    @view_sel.set_submenu(@view_menu)

    @front = Gtk::MenuItem.new(:label => "Front")
    @view_menu.append(@front)
    
    @back = Gtk::MenuItem.new(:label => "Back")
    @view_menu.append(@back)

    @left = Gtk::MenuItem.new(:label => "Left")
    @view_menu.append(@left)
    
    @right = Gtk::MenuItem.new(:label => "Right")
    @view_menu.append(@right)
        
		@menu.append(@view_sel)

		@grid.add(@menu)
		
		
		@canvas = Gtk::DrawingArea.new()
		@canvas.expand = true
		# Creates Drawing widget to sketch N/B object of truck file.

		@grid.add(@canvas)
		# Adds Drawing widget to grid object for interface.

		self.add(@grid)
		# Adds whole grid to window object.

		self.show_all()
		# Shows all widgets inside window at startup.

		self.signal_connect("destroy") {
			|a|
			Gtk::main_quit
		}
		# Will tell gtk to end program when program is x'ed out.

		@front.signal_connect("activate") {
		  @view = 0
		  @canvas.queue_draw()
		}
		
		@back.signal_connect("activate") {
		  @view = 1
		  @canvas.queue_draw()
		}

    @left.signal_connect("activate") {
      @view = 2
      @canvas.queue_draw()
    }
		
    @right.signal_connect("activate") {
      @view = 3
      @canvas.queue_draw()
    }
				
		@open_item.signal_connect("activate") {
			|a|
			open_win = Gtk::FileChooserDialog.new(:title => "Load File", :action => :open, :buttons => [[Gtk::Stock::OPEN, :accept],[Gtk::Stock::CANCEL, :cancel]])
			
			only_truck = Gtk::FileFilter.new()
			only_truck.name = "RoR Truck Files"
			only_truck.add_pattern("*.truck")
			open_win.add_filter(only_truck)

			if open_win.run == Gtk::ResponseType::ACCEPT then
				self.load_truck(open_win.filename())
			end
			open_win.destroy()
		}

		@real_x = @canvas.allocated_width / 2
		@real_y = @canvas.allocated_height / 2
		
		button_clicked = nil

		self.signal_connect("button-press-event") {
      button_clicked = Gdk::BUTTON_PRIMARY
		}
		
		self.signal_connect("motion-notify-event") {
		  |a, b|
		  
		  if (button_clicked & Gdk::EventMask::BUTTON_PRESS_MASK.to_i)
		      @real_x = b.x
		      @real_y = b.y
		      @canvas.queue_draw()
		  end
		}
		
		self.signal_connect("button-release-event") {
		  button_clicked = nil
		}
	end
end

app = RigModder.new()
Gtk.main
# Loads the window when this program is executed
