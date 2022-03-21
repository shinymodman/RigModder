require_relative 'node'

class Shock
	def initialize(req, shock_index)
		@truck = req
		shocks = shock_index >= 0 ? @truck.view_shocks : "invalid_index"

		@shock_properties = {
			node1: Node.new(@truck, shocks[shock_index.to_i][0]),
			node2: Node.new(@truck, shocks[shock_index.to_i][1]),
			spring: shocks[shock_index.to_i][2],
			damping: shocks[shock_index.to_i][3],
			short: shocks[shock_index.to_i][4],
			long: shocks[shock_index.to_i][5],
			precomp: shocks[shock_index.to_i][6],
			options: shocks[shock_index.to_i][7],

		}

	end

	def show_first_node_properties()
		return {
			node_id: @shock_properties[:node1].show_id,
			node_x: @shock_properties[:node1].show_x,
			node_y: @shock_properties[:node1].show_y,
			node_z: @shock_properties[:node1].show_z,
			node_options: @shock_properties[:node1].show_options
		}
	end
	# Shows all of the first node properties using a hash.

	def show_second_node_properties()
		return {
			node_id: @shock_properties[:node2].show_id,
			node_x: @shock_properties[:node2].show_x,
			node_y: @shock_properties[:node2].show_y,
			node_z: @shock_properties[:node2].show_z,
			node_options: @shock_properties[:node2].show_options
		}
	end
	# Shows all of the second node properties using a hash.

	def show_source_x()
		return @truck.strip_arg(show_first_node_properties[:node_x]).to_f
	end
	# X Coord for the first shock.

	def show_source_y()
		return @truck.strip_arg(show_first_node_properties[:node_y]).to_f
	end
	# Y Coord for the first shock.

	def show_source_z()
		return @truck.strip_arg(show_first_node_properties[:node_z]).to_f
	end
	# Z Coord for the first shock.


	def show_dest_x()
		return @truck.strip_arg(show_second_node_properties[:node_x]).to_f
	end
	# X Coord for the second shock.

	def show_dest_y()
		return @truck.strip_arg(show_second_node_properties[:node_y]).to_f
	end
	# Y Coord for the second shock.

	def show_dest_z()
		return @truck.strip_arg(show_second_node_properties[:node_z]).to_f
	end
	# Z Coord for the second shock.	

	def show_options()
		return @truck.strip_arg(@shock_properties[:options])
	end
	# Options for the shock itself.

	def show_first_node()
		return @truck.strip_arg(@shock_properties[:node1].show_id).to_i
	end

	# Shows the first node inside the shock (The node in the first column of the shock)

	def show_second_node()
		return @truck.strip_arg(@shock_properties[:node2].show_id).to_i
	end

	# Shows the first node inside the shock (The node in the first column of the shock)

	# The bottom shows all additional values for shock object.
	def show_spring_value()
		return @truck.strip_arg(@shock_properties[:spring]).to_i
	end
	# Shows the spring (or bounciness) value of a shock.

	def show_damping_value()
		return @truck.strip_arg(@shock_properties[:damping]).to_i
	end
	# Shows the damping (or the resistance of bounciness) value of a shock.

	def show_shortbound_value()
		return @truck.strip_arg(@shock_properties[:short]).to_i
	end
	# Shows how short the shock can be.

	def show_longbound_value()
		return @truck.strip_arg(@shock_properties[:long]).to_i
	end
	# Shows how long the shock can be.

	def show_precompression_value()
		return @truck.strip_arg(@shock_properties[:precomp]).to_i
	end
	# Shows the compression value of the truck when spawned in game.
end