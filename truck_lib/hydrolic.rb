require_relative 'node'

class Hydrolic
	def initialize(req, hydro_index)
		@truck = req
		hydros = hydro_index >= 0 ? @truck.view_hydros : "invalid_index"

		@hydro_properties = {
			node1: Node.new(@truck, hydros[hydro_index.to_i][0]),
			node2: Node.new(@truck, hydros[hydro_index.to_i][1]),
			len_factor: hydros[hydro_index.to_i][2],
			options: hydros[hydro_index][3]
		}

	end

	def show_first_node_properties()
		return {
			node_id: @hydro_properties[:node1].show_id,
			node_x: @hydro_properties[:node1].show_x,
			node_y: @hydro_properties[:node1].show_y,
			node_z: @hydro_properties[:node1].show_z,
			node_options: @hydro_properties[:node1].show_options
		}
	end
	# Shows all of the first node properties using a hash.

	def show_second_node_properties()
		return {
			node_id: @hydro_properties[:node2].show_id,
			node_x: @hydro_properties[:node2].show_x,
			node_y: @hydro_properties[:node2].show_y,
			node_z: @hydro_properties[:node2].show_z,
			node_options: @hydro_properties[:node2].show_options
		}
	end
	# Shows all of the second node properties using a hash.

	def show_source_x()
		return @truck.strip_arg(show_first_node_properties[:node_x]).to_f
	end
	# X Coord for the first hydro.

	def show_source_y()
		return @truck.strip_arg(show_first_node_properties[:node_y]).to_f
	end
	# Y Coord for the first hydro.

	def show_source_z()
		return @truck.strip_arg(show_first_node_properties[:node_z]).to_f
	end
	# Z Coord for the first hydro.


	def show_dest_x()
		return @truck.strip_arg(show_second_node_properties[:node_x]).to_f
	end
	# X Coord for the second hydro.

	def show_dest_y()
		return @truck.strip_arg(show_second_node_properties[:node_y]).to_f
	end
	# Y Coord for the second hydro.

	def show_dest_z()
		return @truck.strip_arg(show_second_node_properties[:node_z]).to_f
	end
	# Z Coord for the second hydro.	

	def show_options()
		return @truck.strip_arg(@hydro_properties[:options])
	end
	# Options for the hydro itself.

	def show_first_node()
		return @truck.strip_arg(@hydro_properties[:node1].show_id).to_i
	end

	# Shows the first node inside the hydro (The node in the first column of the hydro)

	def show_second_node()
		return @truck.strip_arg(@hydro_properties[:node2].show_id).to_i
	end

	# Shows the first node inside the hydro (The node in the first column of the hydro)

	def show_lengthening_factor()
		return @truck.strip_arg(@hydro_properties[:len_factor]).to_i
	end

	# Shows the lengthening factor of the specific hydraulic.
end