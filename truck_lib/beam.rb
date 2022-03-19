require_relative 'node'

class Beam
	def initialize(req, beam_index)
		@truck = req
		beams = beam_index >= 0 ? @truck.view_beams : "invalid_index"

		@beam_properties = {
			node1: Node.new(@truck, beams[beam_index.to_i][0]),
			node2: Node.new(@truck, beams[beam_index.to_i][1]),
			options: beams[beam_index][2]
		}

	end

	def show_first_node_properties()
		return {
			node_id: @beam_properties[:node1].show_id,
			node_x: @beam_properties[:node1].show_x,
			node_y: @beam_properties[:node1].show_y,
			node_z: @beam_properties[:node1].show_z,
			node_options: @beam_properties[:node1].show_options
		}
	end
	# Shows all of the first node properties using a hash.

	def show_second_node_properties()
		return {
			node_id: @beam_properties[:node2].show_id,
			node_x: @beam_properties[:node2].show_x,
			node_y: @beam_properties[:node2].show_y,
			node_z: @beam_properties[:node2].show_z,
			node_options: @beam_properties[:node2].show_options
		}
	end
	# Shows all of the second node properties using a hash.

	def show_source_x()
		return @truck.strip_arg(show_first_node_properties[:node_x]).to_f
	end
	# X Coord for the first beam.

	def show_source_y()
		return @truck.strip_arg(show_first_node_properties[:node_y]).to_f
	end
	# Y Coord for the first beam.

	def show_source_z()
		return @truck.strip_arg(show_first_node_properties[:node_z]).to_f
	end
	# Z Coord for the first beam.


	def show_dest_x()
		return @truck.strip_arg(show_second_node_properties[:node_x]).to_f
	end
	# X Coord for the second beam.

	def show_dest_y()
		return @truck.strip_arg(show_second_node_properties[:node_y]).to_f
	end
	# Y Coord for the second beam.

	def show_dest_z()
		return @truck.strip_arg(show_second_node_properties[:node_z]).to_f
	end
	# Z Coord for the second beam.	

	def show_options()
		return @truck.strip_arg(@beam_properties[:options])
	end
	# Options for the beam itself.

	def show_first_node()
		return @truck.strip_arg(@beam_properties[:node1].show_id).to_i
	end

	# Shows the first node inside the beam (The node in the first column of the beam)

	def show_second_node()
		return @truck.strip_arg(@beam_properties[:node2].show_id).to_i
	end

	# Shows the first node inside the beam (The node in the first column of the beam)
end