require 'gtk3'
require 'cairo'
require 'matrix'

require './truck_lib/node'
require './truck_lib/beam'

class MyApp < Gtk::Window

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

		i = 0

		@button_left.signal_connect("clicked") {
			i -= 90
			@canvas.queue_draw()
		}
		# When left button is clicked, it will tell program to rotate structure to the left

		@button_right.signal_connect("clicked") {
			i += 90
			@canvas.queue_draw()
		}
		# When right button is clicked, it will tell progran to rotate structure to the right

    	size = 250
    	# Initial size for the whole n/b structure

		@canvas.signal_connect("draw") {
			|a, b|
				b.set_source_rgb(1, 0.5, 0)
				# Sets default color to orange

				mat = Cairo::Matrix.new(1, 0, 0, -1, 0, 1080)
				b.set_matrix(mat)
				# This matrix will flip structure in order for it to display correctly

				b.translate(500, 350)
				# Helps move structure anywhere in the Drawing Area

				truck_beam_x.length.times {
					|i|
					b.move_to(truck_beam_z[i][0] * size, truck_beam_y[i][0] * size)
					b.line_to(truck_beam_z[i][1] * size, truck_beam_y[i][1] * size)
				}
				b.stroke()
				# This loop draws out the beams

				b.set_source_rgba(0, 0.5, 0, 0.45)
				# Sets default color to a dark shade of green for the nodes

				truck_node_x.length.times {
					|i|
					b.rectangle(truck_node_z[i] * size, truck_node_y[i] * size, 10, 10)
				}
				b.fill()
				# This loop places the nodes to its respective areas
			}
	end

	def initialize
		super("Hello")
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

		@grid.add(@menu)

		@canvas = Gtk::DrawingArea.new()
		@canvas.expand = true
		# Creates Drawing widget to sketch N/B object of truck file.

		@grid.add(@canvas)
		# Adds Drawing widget to grid object for interface.

		@button_left = Gtk::Button.new(:label => "Left")
		@button_right = Gtk::Button.new(:label => "Right")
		# Creates buttons for rotating object

		@grid.add(@button_left)
		@grid.add(@button_right)
		# Adds button widgets to grid object for interface

		self.add(@grid)
		# Adds whole grid to window object

		self.show_all()
		# Shows all widgets inside window at startup

		self.signal_connect("destroy") {
			|a|
			Gtk::main_quit
		}
		# Will tell gtk to end program when program is x'ed out

		self.load_truck("./sample_truck.truck")
	end
end

app = MyApp.new()
Gtk.main
# Loads the window when this program is executed
