require 'gtk3'
require './truck_lib/truck.rb'
require './truck_lib/node.rb'
require './truck_lib/beam.rb'

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

	def node_data_for_list(widget, file, *node_entries)
  		nodes_in_hash = Hash.new()
  		node_list = Array.new()

  		truck = Truck.new(file)
  		# Gathers node data for listbox and the node dialog.

  		widget.children.each {
  			|a|
  			widget.remove(a)
  		}

  		truck.view_nodes.count.times {
  			|i|
  			node = Node.new(truck, i).show_node_properties()
  			node_list[i] = Gtk::Label.new("#{node[:node_id]}, #{node[:node_x]}, #{node[:node_y]}, #{node[:node_z]}, #{node[:node_opt]}")
  			widget.add(node_list[i])
  		}
  		# Adds all node data into one line in listbox.

  		widget.signal_connect("row-activated") {
  			|a, b|
  			node = Node.new(truck, b.index.to_i)
  			node_entries[0].set_text(node.show_id.to_s)
  			node_entries[1].set_text(node.show_x.to_s)
  			node_entries[2].set_text(node.show_y.to_s)
  			node_entries[3].set_text(node.show_z.to_s)
  			node_entries[4].set_text(node.show_options.to_s)
  		}
  		# Writes properties in respective entries in node dialog.
  	end

    def beam_data_for_list(widget, file, *beam_entries)
      beam_in_hash = Hash.new()
      beam_list = Array.new()

      truck = Truck.new(file)
      # Gathers beam data for listbox and the beam dialog.

      widget.children.each {
        |a|
        widget.remove(a)
      }

      truck.view_beams.count.times {
        |i|
        beam = Beam.new(truck, i)
        beam_list[i] = Gtk::Label.new("#{beam.show_first_node}, #{beam.show_second_node}, #{beam.show_options}")
        widget.add(beam_list[i])
      }
      # Adds all beam data into one line in listbox.

      widget.signal_connect("row-activated") {
        |a, b|
        beam = Beam.new(truck, b.index.to_i)
        beam_entries[0].set_text(beam.show_first_node.to_s)
        beam_entries[1].set_text(beam.show_second_node.to_s)
        beam_entries[2].set_text(beam.show_options.to_s)
      }
      # Writes properties in respective entries in beam dialog.
    end

    def hydro_data_for_list(widget, file, *hydro_entries)
      hydro_in_hash = Hash.new()
      hydro_list = Array.new()

      truck = Truck.new(file)
      # Gathers hydro data for listbox and the hydro dialog.

      widget.children.each {
        |a|
        widget.remove(a)
      }

      truck.view_hydros.count.times {
        |i|
        hydro = Hydrolic.new(truck, i)
        hydro_list[i] = Gtk::Label.new("#{hydro.show_first_node}, #{hydro.show_second_node}, #{hydro.show_lengthening_factor}")
        widget.add(hydro_list[i])
      }
      # Adds all hydro data into one line in listbox.

      widget.signal_connect("row-activated") {
        |a, b|
        hydro = Hydrolic.new(truck, b.index.to_i)
        hydro_entries[0].set_text(hydro.show_first_node.to_s)
        hydro_entries[1].set_text(hydro.show_second_node.to_s)
        hydro_entries[2].set_text(hydro.show_lengthening_factor.to_s)
      }
      # Writes properties in respective entries in hydro dialog.
    end

  	def load_content(loader_widget, *inner_widgets_needed)
  		loader_widget.signal_connect("activate") {
  			|a|
  			filename = self.load_selected_file()

			  DRAW_STRUCTURE.show_loader(filename, inner_widgets_needed[0])

			  self.node_data_for_list(inner_widgets_needed[1], filename, inner_widgets_needed[2], 
				inner_widgets_needed[3], inner_widgets_needed[4], inner_widgets_needed[5], inner_widgets_needed[6]) if !(filename.empty?)

        self.beam_data_for_list(inner_widgets_needed[7], filename, inner_widgets_needed[8], 
        inner_widgets_needed[9], inner_widgets_needed[10]) if !(filename.empty?)

        self.hydro_data_for_list(inner_widgets_needed[11], filename, inner_widgets_needed[12], 
        inner_widgets_needed[13], inner_widgets_needed[14]) if !(filename.empty?)

      }
  	end
end