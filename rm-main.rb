require 'gtk3'

require './truck_backend/loader.rb'
include	DRAW_STRUCTURE

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

			DRAW_STRUCTURE.show_loader(@open_item, @canvas)
			
			DRAW_STRUCTURE.top_selection(@top, @canvas)
			DRAW_STRUCTURE.bottom_selection(@bottom, @canvas)
			DRAW_STRUCTURE.left_selection(@left, @canvas)
			DRAW_STRUCTURE.right_selection(@right, @canvas)
			DRAW_STRUCTURE.front_selection(@front, @canvas)
			DRAW_STRUCTURE.back_selection(@back, @canvas)

			EVENT_FOR_STRUCTURE.click(@main_window, @canvas)
			EVENT_FOR_STRUCTURE.drag_struct(@main_window, @canvas)
			EVENT_FOR_STRUCTURE.zoom_in_or_out(@main_window, @canvas)
		}
	end
end

app = RMApp.new()
puts app.run()