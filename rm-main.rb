require 'gtk3'

require './truck_backend/sketcher.rb'
include	DRAW_STRUCTURE

require './truck_backend/loader.rb'
include LOAD_TRUCK_FILE

require './truck_backend/events.rb'
include EVENT_FOR_STRUCTURE
# Scripts and module required for handling Gtk signals and events

class RMApp < Gtk::Application
	def initialize()
		super("com.shinymodman.RigModder", :flags_none)

		
		self.signal_connect("activate") {
			|a|

			@main_window = Gtk::ApplicationWindow.new(a)
			@main_window.set_title("RigModder")
			@main_window.set_default_size(1080, 720)

			@grid = Gtk::Box.new(:vertical)
			# Declares grid object for holding a couple of gtk widgets

			@menu = Gtk::MenuBar.new()
			# Adds the entire menu on the top of the interface.
			
			@file_menu = Gtk::Menu.new()
			@file_sel = Gtk::MenuItem.new(:label => "File")
			@file_sel.set_submenu(@file_menu)
			@menu.append(@file_sel)
			# This adds the File dropdown to the top menu.
			
			@open_item = Gtk::MenuItem.new(:label => "Open")
			@file_menu.append(@open_item)
	    	# Creates and adds the selection saying Open to the View dropdown.
			
			@view_menu = Gtk::Menu.new()
			@view_sel = Gtk::MenuItem.new(:label => "View")
		    @view_sel.set_submenu(@view_menu)
		    # This adds the View dropdown to the top menu.
		    
		    
		    @front = Gtk::MenuItem.new(:label => "Front")
		    @view_menu.append(@front)
		    # Creates and adds the selection saying front to the View dropdown.
		    
		    @back = Gtk::MenuItem.new(:label => "Back")
		    @view_menu.append(@back)
		    # Creates and adds the selection saying back to the View dropdown.
		    
		    @left = Gtk::MenuItem.new(:label => "Left")
		    @view_menu.append(@left)
		    # Creates and adds the selection saying left to the View dropdown.
		    
		    @right = Gtk::MenuItem.new(:label => "Right")
		    @view_menu.append(@right)
		    # Creates and adds the selection saying right to the View dropdown.
		    
		    @top = Gtk::MenuItem.new(:label => "Top")
		    @view_menu.append(@top)
		    # Creates and adds the selection saying top to the View dropdown.
		    
		    @bottom = Gtk::MenuItem.new(:label => "Bottom")
		    @view_menu.append(@bottom)
		    # Creates and adds the selection saying bottom to the View dropdown.
	    	
	    	@node_dialog = Gtk::MenuItem.new(:label => "Node List")
	    	@view_menu.append(@node_dialog)
	    	# Creates a way to view dialog with a node list

			@menu.append(@view_sel)
			@grid.add(@menu)
			# Creates and inserts the dropdown menu widget to the window.
			
			@canvas = Gtk::DrawingArea.new()
			@canvas.expand = true
			# Creates Drawing widget to sketch N/B object of truck file.

			@grid.add(@canvas)
			# Adds Drawing widget to grid object for interface.

			@main_window.add(@grid)
			# Adds whole grid to window object.

			@main_window.show_all()
			# Shows all widgets inside window at startup.

			@main_window.signal_connect("destroy") {
				|a|
				@main_window.destroy()
			}
			# Will tell gtk to end program when program is x'ed out.
			
			DRAW_STRUCTURE.top_selection(@top, @canvas)
			DRAW_STRUCTURE.bottom_selection(@bottom, @canvas)
			DRAW_STRUCTURE.left_selection(@left, @canvas)
			DRAW_STRUCTURE.right_selection(@right, @canvas)
			DRAW_STRUCTURE.front_selection(@front, @canvas)
			DRAW_STRUCTURE.back_selection(@back, @canvas)

			EVENT_FOR_STRUCTURE.click(@main_window, @canvas)
			EVENT_FOR_STRUCTURE.drag_struct(@main_window, @canvas)
			EVENT_FOR_STRUCTURE.zoom_in_or_out(@main_window, @canvas)


			@window = Gtk::Window.new()
			@window.set_title("Nodes")
			# Object to create Node window

			@dialog_grid = Gtk::Box.new(:vertical, 2)
			# Widget object to place multiple widgets on node dialog.

			@node_list = Gtk::ListBox.new()
			# Widget object to show each node object in one line

			@node_list.expand = true
			# Property to set node widget expanded by Gtk3

			@scrollbar = Gtk::ScrolledWindow.new()
    		@dialog_grid.pack_start(@scrollbar, :fill => true, :expand => true, :padding => 0)
    		@scrollbar.add(@node_list)
    		# Adds scrolling ability to make room for dialog on editor widgets.

			@node_property_grid = Gtk::Box.new(:horizontal)
			@node_property_x_grid = Gtk::Box.new(:horizontal)
			@node_property_y_grid = Gtk::Box.new(:horizontal)
			@node_property_z_grid = Gtk::Box.new(:horizontal)
			@node_property_opt_grid = Gtk::Box.new(:horizontal)
			# Grids to place node property widgets in its respecitve areas.

			@label_node = Gtk::Label.new()
			@node_entry = Gtk::Entry.new()
			@label_node.set_text("Node:")
			@node_property_grid.add(@label_node)
			@node_property_grid.pack_end(@node_entry, :expand => true, :fill => true, :padding => 0)
			# Sets up widgets for showing node id.

			@label_node_x = Gtk::Label.new()
			@node_x_entry = Gtk::Entry.new()
			@label_node_x.set_text("X:")			
			@node_property_x_grid.add(@label_node_x)
			@node_property_x_grid.pack_end(@node_x_entry, :expand => true, :fill => true, :padding => 0)
			# Sets up widgets for showing node X coord.


			@label_node_y = Gtk::Label.new()
			@node_y_entry = Gtk::Entry.new()
			@label_node_y.set_text("Y:")			
			@node_property_y_grid.add(@label_node_y)
			@node_property_y_grid.pack_end(@node_y_entry, :expand => true, :fill => true, :padding => 0)
			# Sets up widgets for showing node Y coord.

			@label_node_z = Gtk::Label.new()
			@node_z_entry = Gtk::Entry.new()
			@label_node_z.set_text("Z:")			
			@node_property_z_grid.add(@label_node_z)
			@node_property_z_grid.pack_end(@node_z_entry, :expand => true, :fill => true, :padding => 0)
			# Sets up widgets for showing node Z coord.

			@label_node_opt = Gtk::Label.new()
			@node_opt_entry = Gtk::Entry.new()
			@label_node_opt.set_text("Opt:")			
			@node_property_opt_grid.add(@label_node_opt)
			@node_property_opt_grid.pack_end(@node_opt_entry, :expand => true, :fill => true, :padding => 0)
			# Sets up widgets for showing node option data.

			@dialog_grid.add(@node_property_grid)
			@dialog_grid.add(@node_property_x_grid)
			@dialog_grid.add(@node_property_y_grid)
			@dialog_grid.add(@node_property_z_grid)
			@dialog_grid.add(@node_property_opt_grid)
			# Places widgets and their placeholder to show widgets properly.

			EVENT_FOR_STRUCTURE.load_dialog(@node_dialog, @window, 800, 350, @dialog_grid)
			LOAD_TRUCK_FILE.load_content(@open_item, @canvas, @node_list, @node_entry, @node_x_entry,
				@node_y_entry, @node_z_entry, @node_opt_entry)
			DRAW_STRUCTURE.set_node_selector(@node_list)
			# Procedural methods that load content into the app.
		}
	end
end

app = RMApp.new()
puts app.run()