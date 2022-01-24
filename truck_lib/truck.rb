require 'csv'

class Truck
	def initialize(req)
		@file = (File.exist?(req) && File.extname(".truck")) ? CSV.parse(File.new(req)) : "invalid_file" 
	end
	# Gathers all content of file if the file exists or is valid and has the .truck extension. Otherwise writes the string: "invaid_file"

	def verify_file()
		return @file
		
	end
	# Shows all content of file if the file exists is valid and has the .truck extension. Otherwise writes the string: "invaid_file"

	def view_nodes()

		return @file.to_a.select {
			|a|

			a if (a.length == 5 || a.length == 4) && 
			!(/\D/.match(a[0])) && # Checks if it has only letters, symbols and whitespace, which is only supported in the beams and this column and section
			(/\d/.match(a[1])) && # Checks if it has only numbers, which is only supported in the beams and this column and section
			(/\d/.match(a[2])) && # Checks if it has only numbers, which is only supported in the beams and this column and section
			(/\d/.match(a[3])) # Checks if it has only numbers, which is only supported in the beams and this column and section
		}
		# Lists node objects in flare section
	end

	def view_beams()

		return @file.to_a.select {
			|a|

			a if (a.length == 3) && # The amount content that a beam object is only supposed to have
			!(/\D/.match(a[0])) && # Checks 1st column for non letters, whitespaces and symbols. Which is not supported in this section
			(/\d/.match(a[1])) && # Checks if it has only numbers, which is only supported in the beams section
			!(/\d/.match(a[2])) && # Checks if it has only numbers on the last argument of the beam itself.
			(a[0] > a.last) # Checks if the first argument of the beam is bigger than the last node id.
		}
		# Lists beam objects in flare section
	end

	def view_flares()

		return @file.to_a.select {
			|a|

			a if (a.length == 9 || a.length == 10) && # The amount content that a flare object is supposed to have
			!(/\D/.match(a[0])) && # Checks 1st column for non letters, whitespaces and symbols. Which is not supported in this section
			(/[a-zA-Z]/.match(a[5])) # Checks 6th column for valid options. This checks if only letters are on there.
		}
		# Lists flare objects in flare section
	end

	def strip_arg(str)
		if /\s/.match(str.to_s) then
			return str.to_s.strip!
		else
			return str.to_s
		end
	end
end