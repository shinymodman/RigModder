require './Truck'

class Node
	def initialize(req, node_index)
		truck = req

		nodes = truck.view_nodes()
		@main_node = {
			node_id: nodes[node_index][0],
			node_x: nodes[node_index][1],
			node_y: nodes[node_index][2],
			node_z: nodes[node_index][3],
			node_opt: nodes[node_index][4]
		}
	end

	def show_id()
		return @main_node[:node_id]
	end

	def show_x()
		return @main_node[:node_x].strip!
	end

	def show_y()
		return @main_node[:node_y].strip!
	end

	def show_z()
		return @main_node[:node_z].strip!
	end

	def show_options()
		return @main_node[:node_opt].strip!
	end
end