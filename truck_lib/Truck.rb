require 'csv'

class Truck
	def initialize(req)
		@file = (File.exist?(req) && File.extname(".truck")) ? CSV.parse(File.new(req)) : "invalid_file" 
	end

	def verify_file()
		return @file
	end

	def view_nodes()

		first_selection = @file.to_a.select {
			|a|

			a if (a.length == 5 || a.length == 4) && 
			!(/\D/.match(a[0])) &&
			(/\d/.match(a[1])) &&
			(/\d/.match(a[2])) &&
			(/\d/.match(a[3]))

		}
	end

	def view_beams()
		return @file.to_a.select {
			|a|

			a if (a.length == 3) && 
			!(/\D/.match(a[0])) &&
			(/\d/.match(a[1]))

		}.inspect
	end
end