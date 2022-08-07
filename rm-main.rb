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


	    	@node_dialog = Gtk::MenuItem.new(:label => "Nodes")
	    	@view_menu.append(@node_dialog)
	    	# Creates a way to view dialog with a node list

	    	@beam_dialog = Gtk::MenuItem.new(:label => "Beams")
	    	@view_menu.append(@beam_dialog)
	    	#Creates a way to view dialog with a beam list

			@menu.append(@view_sel)
			# Adds whole view menu to the whole user interface.

			@camera_menu = Gtk::Menu.new()
			@camera_sel = Gtk::MenuItem.new(:label => "Camera")
		    @camera_sel.set_submenu(@camera_menu)
		    # This adds the View dropdown to the top menu.
		    
		    @front = Gtk::MenuItem.new(:label => "Front")
		    @camera_menu.append(@front)
		    # Creates and adds the selection saying front to the View dropdown.
		    
		    @back = Gtk::MenuItem.new(:label => "Back")
		    @camera_menu.append(@back)
		    # Creates and adds the selection saying back to the View dropdown.
		    
		    @left = Gtk::MenuItem.new(:label => "Left")
		    @camera_menu.append(@left)
		    # Creates and adds the selection saying left to the View dropdown.
		    
		    @right = Gtk::MenuItem.new(:label => "Right")
		    @camera_menu.append(@right)
		    # Creates and adds the selection saying right to the View dropdown.
		    
		    @top = Gtk::MenuItem.new(:label => "Top")
		    @camera_menu.append(@top)
		    # Creates and adds the selection saying top to the View dropdown.
		    
		    @bottom = Gtk::MenuItem.new(:label => "Bottom")
		    @camera_menu.append(@bottom)
		    # Creates and adds the selection saying bottom to the View dropdown.
	    	
			@menu.append(@camera_sel)
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

			EVENT_FOR_STRUCTURE.click(@main_window, @canvas)
			EVENT_FOR_STRUCTURE.drag_or_rotate_struct(@main_window, @canvas)
			EVENT_FOR_STRUCTURE.zoom_in_or_out(@main_window, @canvas)


			@window = Gtk::Window.new()
			@window.set_title("Nodes")
			@window.type_hint = :dialog
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

			@beam_window = Gtk::Window.new()
			@beam_window.set_title("Beams")
			@beam_window.type_hint = :dialog

			@beam_list = Gtk::ListBox.new()
			@beam_list.expand = true

			@beam_container = Gtk::Box.new(:vertical, 2)
			@beam_scrollbar = Gtk::ScrolledWindow.new()

			@beam_property_opt_grid = Gtk::Box.new(:horizontal)
			@beam_property_id1_grid = Gtk::Box.new(:horizontal)
			@beam_property_id2_grid = Gtk::Box.new(:horizontal)
			# Grids to place node property widgets in its respecitve areas.

			@label_beam_id1 = Gtk::Label.new()
			@beam_id1_entry = Gtk::Entry.new()
			@label_beam_id1.set_text("Node 1:")
			@beam_property_id1_grid.add(@label_beam_id1)
			@beam_property_id1_grid.pack_end(@beam_id1_entry, :expand => true, :fill => true, :padding => 0)
			# Sets up widgets for showing primary node id data.

			@label_beam_id2 = Gtk::Label.new()
			@beam_id2_entry = Gtk::Entry.new()
			@label_beam_id2.set_text("Node 2:")
			@beam_property_id2_grid.add(@label_beam_id2)
			@beam_property_id2_grid.pack_end(@beam_id2_entry, :expand => true, :fill => true, :padding => 0)
			# Sets up widgets for showing secondary node id data.

			@label_beam_opt = Gtk::Label.new()
			@beam_opt_entry = Gtk::Entry.new()
			@label_beam_opt.set_text("Opt:")			
			@beam_property_opt_grid.add(@label_beam_opt)
			@beam_property_opt_grid.pack_end(@beam_opt_entry, :expand => true, :fill => true, :padding => 0)
			# Sets up widgets for showing node option data.

			@beam_scrollbar.add(@beam_list)
			@beam_container.add(@beam_scrollbar)

			@beam_container.add(@beam_property_id1_grid)
			@beam_container.add(@beam_property_id2_grid)
			@beam_container.add(@beam_property_opt_grid)
			@beam_window.add(@beam_container)

			EVENT_FOR_STRUCTURE.load_dialog(@node_dialog, @window, 800, 350, @dialog_grid)
			EVENT_FOR_STRUCTURE.load_dialog(@beam_dialog, @beam_window, 800, 350, @beam_container)
			LOAD_TRUCK_FILE.load_content(@open_item, @canvas, @node_list, @node_entry, @node_x_entry,
				@node_y_entry, @node_z_entry, @node_opt_entry)
			DRAW_STRUCTURE.set_node_selector(@node_list)
			# Procedural methods that load content into the app.
		}
	end
end

app = RMApp.new()
puts app.run()