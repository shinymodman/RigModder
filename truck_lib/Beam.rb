require './Node'

class Beam
	def initialize(req, beam_index)
		truck = req
		beams = truck.view_beams

		@beam_properties = {
			node1: Node.new(truck, beams[beam_index][0].to_i),
			node2: Node.new(truck, beams[beam_index][1].to_i),
			options: beams[beam_index][2] 
		}

	end

	def show_first_node_properties()
		return {
			node_id: @beam_properties[:node1].show_id.to_i,
			node_x: @beam_properties[:node1].show_x.to_f,
			node_y: @beam_properties[:node1].show_y.to_f,
			node_z: @beam_properties[:node1].show_z.to_f,
			node_options: @beam_properties[:node1].show_options
		}
	end
	# Shows all of the first node properties using a hash.

	def show_second_node_properties()
		return {
			node_id: @beam_properties[:node2].show_id.to_i,
			node_x: @beam_properties[:node2].show_x.to_f,
			node_y: @beam_properties[:node2].show_y.to_f,
			node_z: @beam_properties[:node2].show_z.to_f,
			node_options: @beam_properties[:node2].show_options
		}
	end
	# Shows all of the second node properties using a hash.

	def show_source_x()
		return self.show_first_node_properties[:node_x]
	end
	# X Coord for the first beam.

	def show_source_y()
		return self.show_first_node_properties[:node_y]
	end
	# Y Coord for the first beam.

	def show_source_z()
		return self.show_first_node_properties[:node_z]
	end
	# Z Coord for the first beam.


	def show_dest_x()
		return self.show_second_node_properties[:node_x]
	end
	# X Coord for the second beam.

	def show_dest_y()
		return self.show_second_node_properties[:node_y]
	end
	# Y Coord for the second beam.

	def show_dest_z()
		return self.show_second_node_properties[:node_z]
	end
	# Z Coord for the second beam.	

	def show_options()
		return @main_node[:node_opt].strip!
	end
	# Options for the beam itself.

	def show_first_node()
		return @beam_properties[:node1].show_id.to_i
	end

	# Shows the first node inside the beam (The node in the first column of the beam)

	def show_second_node()
		return @beam_properties[:node2].show_id.to_i
	end

	# Shows the first node inside the beam (The node in the first column of the beam)
end
