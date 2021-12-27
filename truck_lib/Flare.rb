require './Truck'

class Flare
	def initialize(req, flare_id)
		truck = req
		flares = truck.view_flares

		@flare_count = truck.view_flares.count
		@flare_coord_info = {
			ref_node: flares[flare_id][0],
			ref_x: flares[flare_id][1],
			ref_y: flares[flare_id][2],
			pos_x: flares[flare_id][3],
			pos_y: flares[flare_id][4],
			f_type: flares[flare_id][5]
		}
	end

	def show_flare_properties()
		return @flare_coord_info.inspect
	end

	def get_total_flares()
		return @flare_count
	end
end
