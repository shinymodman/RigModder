# node.rb

require_relative 'truck'

class Node
	def initialize(req, node_index)
		@truck = req
		nodes = @truck.view_nodes()

		@main_node = {
			node_id: nodes[node_index.to_i][0],
			node_x: nodes[node_index.to_i][1],
			node_y: nodes[node_index.to_i][2],
			node_z: nodes[node_index.to_i][3],
			node_opt: nodes[node_index.to_i][4]
		}
	end

	def show_node_properties()
		return @main_node
	end

	def show_id()
		return @truck.strip_arg(@main_node[:node_id]).to_i
	end

	def show_x()
		return @truck.strip_arg(@main_node[:node_x]).to_f
	end

	def show_y()
		return @truck.strip_arg(@main_node[:node_y]).to_f
	end

	def show_z()
		return @truck.strip_arg(@main_node[:node_z]).to_f
	end

	def show_options()
		return @truck.strip_arg(@main_node[:node_opt])
	end
end