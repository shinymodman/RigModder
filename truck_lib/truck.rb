require 'csv'

class Truck
	@req = nil

	def initialize(req)
		@file = (File.exist?(req) && File.extname(".truck")) ? CSV.parse(File.new(req)) : "invalid_file"
		@req = req
	end
	# Gathers all content of file if the file exists or is valid and has the .truck extension. Otherwise writes the string: "invaid_file"

	def self.verify_file(truck_file)
		return (File.exist?(truck_file) && File.extname(".truck")) ? "valid" : "invalid_file"
	end

	def verify_file()
		return @file
		
	end
	# Shows all content of file if the file exists is valid and has the .truck extension. Otherwise writes the string: "invaid_file"

	def view_nodes()

		return @file.to_a.select {
			|a|

			a if (a.length <= 5) && 
			!(/\D/.match(a[0])) && # Checks if it has only letters, symbols and whitespace, which is only supported in the beams and this column and section
			(/\d/.match(a[1])) && # Checks if it has only numbers, which is only supported in the beams and this column and section
			(/\d/.match(a[2])) && # Checks if it has only numbers, which is only supported in the beams and this column and section
			!(/[a-zA-Z0-9]{2,}.[a-zA-Z]{2,}$/.match(a[3])) &&
			(/\d/.match(a[3])) && # Checks if it has only numbers, which is only supported in the beams and this column and section
			(/[^[0-9]*]/.match(a[4]) || a[4].nil?)
		}
		# Lists node objects in flare section
	end

	def view_beams()

		beams =  @file.to_a.select {
			|a|

			a if (a.length > 1 && a.length <= 3) && # The amount content that a beam object is only supposed to have
			!((/\D/.match(a[0]))) && # Checks 1st column for non letters, whitespaces and symbols. Which is not supported in this section
			!((/[0-9]{4,}/.match(a[0]))) &&
			!(/[0-9]\.[0-9]{0,3}/.match(a[1])) &&  # Checks if it has only numbers, which is only supported in the beams section
			!(/[a-zA-Z]/.match(a[1])) &&
			!(/[0-9]{4,}/.match(a[1])) && 
			!(/([\w]+[.\/][\w]+|[0-9]{4,})/.match(a[2])) && # Checks if it has only numbers on the last argument of the beam itself.
			!((/[0-9]{1}/.match(a[2]))) && # Checks if it the third argument does not have any numbers.
			!(a.empty? || a[2].nil?)
		}
		# Lists beam objects in flare section

	end

	def view_hydros()

		return @file.to_a.select {
			|a|

			a if (a.length <= 4) && # The amount content that a beam object is only supposed to have
			!(/\D/.match(a[0])) && # Checks 1st column for non letters, whitespaces and symbols. Which is not supported in this section
			!(/\d*[.]/.match(a[1])) && # Checks if it has only numbers, which is only supported in the beams section
			(/[-0-9]+\.[0-9]+/.match(a[2])) && # Checks if the argument is only an decimal/floating point number which is only supported there.
			((/[^isareuvxygh][^\s]/.match(a[3])) || a[3].nil?)

		}
		# Lists beam objects in flare section
	end

	def view_shocks()

		return @file.to_a.select {
			|a|

			a if (a.length == 8 || a.length == 7) && # The amount content that a beam object is only supposed to have	
			!(/\D/.match(a[0])) && # Checks 1st column for non letters, whitespaces and symbols. Which is not supported in this section
			!(/[a-zA-Z]\d*/.match(a[3])) &&
			(/[^a-zA-Z]$/.match(a[5])) &&
			(/[a-zA-Z]*/.match(a[6]))


		}
		# Lists shock objects in flare section
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
		if (/\s/.match(str.to_s)) then
			return str.strip
		else
			return str.to_s.strip
		end
	end

	def filename()
		return @req
	end
end