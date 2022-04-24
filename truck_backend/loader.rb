require 'gtk3'
require './truck_lib/truck.rb'
require './truck_lib/node.rb'

require_relative './sketcher.rb'
include DRAW_STRUCTURE

module LOAD_TRUCK_FILE
	def load_selected_file()
		filename = ''
		open_win = Gtk::FileChooserDialog.new(:title => "Load File", :action => :open, :buttons => [[Gtk::Stock::OPEN, :accept],[Gtk::Stock::CANCEL, :cancel]])
			# Creates the configuration to load a truck file to the program.

		only_truck = Gtk::FileFilter.new()
		only_truck.name = "RoR Truck Files"
		only_truck.add_pattern("*.truck")
		open_win.add_filter(only_truck)
		# Creates the filter so other files without the extension ".truck" are excluded from the file chooser.
		
		if open_win.run == Gtk::ResponseType::ACCEPT
			filename = open_win.filename()
		end
		# This will start the file handling after file is selected and accepted by the file chooser.
		
		open_win.destroy()

		while Gtk.events_pending?
		  	Gtk.main_iteration
		end

		return filename
  	end

	def node_data_for_list(widget, file)
  		nodes_in_hash = Hash.new()
  		node_list = Array.new()
  		truck = Truck.new(file)

  		truck.view_nodes.count.times {
  			|i|
  			node = Node.new(truck, i).show_node_properties()
  			node_list[i] = Gtk::Label.new("#{node[:node_id]}, #{node[:node_x]}, #{node[:node_y]}, #{node[:node_z]}, #{node[:node_opt]}")
  			widget.add(node_list[i])
  		}
  	end

  	def load_selected_node(widget, result_holder, canvas)

  		widget.signal_connect("row-activated") {
  			|a, b|
  			result_holder = b.index
  			puts result_holder
  		}

  		canvas.queue_draw
  	end

  	def load_content(loader_widget, *inner_widgets_needed)
  		loader_widget.signal_connect("activate") {
  			|a|
  			filename = self.load_selected_file()
			DRAW_STRUCTURE.show_loader(filename, inner_widgets_needed[0], inner_widgets_needed[1])
			self.node_data_for_list(inner_widgets_needed[1], filename)
  		}
  	end
end