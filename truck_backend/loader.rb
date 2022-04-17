require 'gtk3'
require './truck_lib/truck.rb'


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
		
		if open_win.run == Gtk::ResponseType::ACCEPT then
			filename = open_win.filename() if open_win.filename().is_a?(String)
		end
		# This will start the file handling after file is selected and accepted by the file chooser.
		
		open_win.destroy()

		while Gtk.events_pending?
		  	Gtk.main_iteration
		end

		return filename
  	end
end