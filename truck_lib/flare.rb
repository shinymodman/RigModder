# flare.rb

require_relative 'truck'

class Flare

	public
	def initialize(req, flare_id)
		@truck = req
		flares = @truck.view_flares

		@flare_coord_info = {
			ref_node: flares[flare_id][0].to_i,
			ref_x: flares[flare_id][1].to_i,
			ref_y: flares[flare_id][2].to_i,
			pos_x: flares[flare_id][3].to_i,
			pos_y: flares[flare_id][4].to_i,
			f_type: flares[flare_id][5]
		}
	end

	def show_flare_properties()
		return @flare_coord_info
	end

	def get_reference_node()
		return @truck.strip_arg(@flare_coord_info[:ref_node])
	end

	def get_reference_x()
		return @truck.strip_arg(@flare_coord_info[:ref_x])
	end

	def get_reference_y()
		return @truck.strip_arg(@flare_coord_info[:ref_y])
	end

	def get_coord_x()
		return @truck.strip_arg(@flare_coord_info[:pos_x])
	end

	def get_coord_y()
		return @truck.strip_arg(@flare_coord_info[:pos_y])
	end

	def get_flare_type()
		return @truck.strip_arg(@flare_coord_info[:f_type])
	end
end