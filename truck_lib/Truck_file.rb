require 'csv'

class Truck
	def initialize(req)
		@file = (File.exist?(req) && File.extname(".truck")) ? CSV.parse(File.new(req)) : "invalid_file" 
	end

	def verify_file()
		return @file
	end

	def view_nodes()
		return @file.to_a.select {

			|a| 
			a if ((a.length == 5) && !(a[0].match(";")))

		}.inspect
	end
end

test = Truck.new("C://Users//Summe//Desktop//ThomasShorty.truck")

puts test.view_nodes