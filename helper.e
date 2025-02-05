class HELPER

feature {ANY}

	hextoint (hex_string: STRING): NATURAL_64
		local
			converter: HEXADECIMAL_STRING_TO_INTEGER_CONVERTER
		do
				-- Create an instance of the converter
			create converter.make

				-- Initialize the string to be parsed

				-- Start a parsing session with the string
			converter.reset ({HEXADECIMAL_STRING_TO_INTEGER_CONVERTER}.Type_NATURAL_64)

				-- Parse the string (case-insensitive for hexadecimal)
			converter.parse_string_with_type (hex_string, {HEXADECIMAL_STRING_TO_INTEGER_CONVERTER}.Type_NATURAL_64)

				-- Check if parsing was successful
			if converter.parse_successful then
					-- Get the parsed result as NATURAL_64
				Result := converter.parsed_NATURAL_64
					-- Output the result
					--io.put_string("Parsed NATURAL_64: " + result.out + "%N")
			else
					--io.put_string("Parsing failed.%N")
			end
		ensure
			class
		end

	c_bit_shift_right (inp: NATURAL_64; n: INTEGER): NATURAL_64
		local
			temp1, temp2: NATURAL_64
			m: INTEGER
		do
			m := n \\ 64
			if m = 0 then
				Result := inp
			else
				temp1 := inp.bit_shift_right (m)
				temp2 := inp.bit_shift_left (64 - m)
				Result := temp1.bit_or (temp2)
			end

		end

	c_bit_shift_left (inp: NATURAL_64; n: INTEGER): NATURAL_64
		local
			temp1, temp2: NATURAL_64
			m: INTEGER
		do
			m := n \\ 64
			if m = 0 then
				Result := inp
			else
				temp1 := inp.bit_shift_left (m)
				temp2 := inp.bit_shift_right (64 - m)
				Result := temp1.bit_or (temp2)
			end

		end

end
