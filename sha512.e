class SHA512

create
	make

feature

	a, b, c, d, e, f, g, h: NATURAL_64
	ks: ARRAY [NATURAL_64]

	make
		do
			a := 0x6A09E667F3BCC908
			b := 0xBB67AE8584CAA73B
			c := 0x3C6EF372FE94F82B
			d := 0xA54FF53A5F1D36F1
			e := 0x510E527FADE682D1
			f := 0x9B05688C2B3E6C1F
			g := 0x1F83D9ABFB41BD6B
			h := 0x5BE0CD19137E2179

			ks := <<0x428A2F98D728AE22, 0x7137449123EF65CD, 0xB5C0FBCFEC4D3B2F, 0xE9B5DBA58189DBBC,
					0x3956C25BF348B538, 0x59F111F1B605D019, 0x923F82A4AF194F9B, 0xAB1C5ED5DA6D8118,
					0xD807AA98A3030242, 0x12835B0145706FBE, 0x243185BE4EE4B28C, 0x550C7DC3D5FFB4E2,
					0x72BE5D74F27B896F, 0x80DEB1FE3B1696B1, 0x9BDC06A725C71235, 0xC19BF174CF692694,
					0xE49B69C19EF14AD2, 0xEFBE4786384F25E3, 0x0FC19DC68B8CD5B5, 0x240CA1CC77AC9C65,
					0x2DE92C6F592B0275, 0x4A7484AA6EA6E483, 0x5CB0A9DCBD41FBD4, 0x76F988DA831153B5,
					0x983E5152EE66DFAB, 0xA831C66D2DB43210, 0xB00327C898FB213F, 0xBF597FC7BEEF0EE4,
					0xC6E00BF33DA88FC2, 0xD5A79147930AA725, 0x06CA6351E003826F, 0x142929670A0E6E70,
					0x27B70A8546D22FFC, 0x2E1B21385C26C926, 0x4D2C6DFC5AC42AED, 0x53380D139D95B3DF,
					0x650A73548BAF63DE, 0x766A0ABB3C77B2A8, 0x81C2C92E47EDAEE6, 0x92722C851482353B,
					0xA2BFE8A14CF10364, 0xA81A664BBC423001, 0xC24B8B70D0F89791, 0xC76C51A30654BE30,
					0xD192E819D6EF5218, 0xD69906245565A910, 0xF40E35855771202A, 0x106AA07032BBD1B8,
					0x19A4C116B8D2D0C8, 0x1E376C085141AB53, 0x2748774CDF8EEB99, 0x34B0BCB5E19B48A8,
					0x391C0CB3C5C95A63, 0x4ED8AA4AE3418ACB, 0x5B9CCA4F7763E373, 0x682E6FF3D6B2B8A3,
					0x748F82EE5DEFB2FC, 0x78A5636F43172F60, 0x84C87814A1F0AB72, 0x8CC702081A6439EC,
					0x90BEFFFA23631E28, 0xA4506CEBDE82BDE9, 0xBEF9A3F7B2C67915, 0xC67178F2E372532B,
					0xCA273ECEEA26619C, 0xD186B8C721C0C207, 0xEADA7DD6CDE0EB1E, 0xF57D4F7FEE6ED178,
					0x06F067AA72176FBA, 0x0A637DC5A2C898A6, 0x113F9804BEF90DAE, 0x1B710B35131C471B,
					0x28DB77F523047D84, 0x32CAAB7B40C72493, 0x3C9EBE0A15C9BEBC, 0x431D67C49C100D4C,
					0x4CC5D4BECB3E42B6, 0x597F299CFC657E2A, 0x5FCB6FAB3AD6FAEC, 0x6C44198C4A475817>>
		end

	add_padding (plaintext: STRING; zeros: INTEGER): STRING
		do
			Result := plaintext + "8" + create {STRING}.make_filled ('0', zeros - 1)
		end

	add_size (plaintext: STRING; size: INTEGER): STRING
		local
			nzeros: INTEGER
			sizeHex128bit: STRING
		do
			sizeHex128bit := (size * 4).to_hex_string
			nzeros := 32 - sizeHex128bit.count
			sizeHex128bit := create {STRING}.make_filled ('0', nzeros) + sizeHex128bit
			Result := plaintext + sizeHex128bit
		end

	sigma0 (inp: NATURAL_64): NATURAL_64
		do
			Result := c_bit_shift_right (inp, 1)
			Result := Result.bit_xor (c_bit_shift_right (inp, 8))
			Result := Result.bit_xor (inp.bit_shift_right (7))
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

	sigma1 (inp: NATURAL_64): NATURAL_64
		do
			Result := c_bit_shift_right (inp, 19)
			Result := Result.bit_xor (c_bit_shift_right (inp, 61))
			Result := Result.bit_xor (inp.bit_shift_right (6))
		end

	schedule_words (chunk: ARRAY [NATURAL_64]; scheduled_words: ARRAY [NATURAL_64])
		local
			i: INTEGER
		do
			scheduled_words.subcopy (chunk, 1, 16, 1)
			from i := 17
			until i > 80
			loop
				scheduled_words [i] := sigma1 (scheduled_words [i - 2]) + scheduled_words [i - 7] + sigma0 (scheduled_words [i - 15]) + scheduled_words [i - 16]
				i := i + 1
			end

				--print("scheduled words: %N")
				--print(scheduled_words)
				--print("chunk: %N")
				--print(chunk)
		end

	Ch (le, lf, lg: NATURAL_64): NATURAL_64
		do
			Result := le.bit_and (lf)
			Result := Result.bit_xor (le.bit_not.bit_and (lg))
		end

	E5121 (inp: NATURAL_64): NATURAL_64
		do
			Result := c_bit_shift_right (inp, 14)
			Result := Result.bit_xor (c_bit_shift_right (inp, 18))
			Result := Result.bit_xor (c_bit_shift_right (inp, 41))
		end

	E5120 (inp: NATURAL_64): NATURAL_64
		do
			Result := c_bit_shift_right (inp, 28)
			Result := Result.bit_xor (c_bit_shift_right (inp, 34))
			Result := Result.bit_xor (c_bit_shift_right (inp, 39))
		end

	Maj (la, lb, lc: NATURAL_64): NATURAL_64
		do
			Result := la.bit_and (lb)
			Result := Result.bit_xor (la.bit_and (lc))
			Result := Result.bit_xor (lb.bit_and (lc))
		end

	round (word: NATURAL_64; lr: ARRAY [NATURAL_64]; k: NATURAL_64)
		local
			T1, T2: NATURAL_64
		do
				--print("word: "+word.to_hex_string + "%N")
			T1 := lr [8] + Ch (lr [5], lr [6], lr [7]) + E5121 (lr [5]) + word + k
			T2 := E5120 (lr [1]) + Maj (lr [1], lr [2], lr [3])
			lr [8] := lr [7]
			lr [7] := lr [6]
			lr [6] := lr [5]
			lr [5] := lr [4] + T1
			lr [4] := lr [3]
			lr [3] := lr [2]
			lr [2] := lr [1]
			lr [1] := T1 + T2
		end

	FFunction (chunk: ARRAY [NATURAL_64]; HValue: ARRAY [NATURAL_64]): ARRAY [NATURAL_64]
		local
			lr, scheduled_words: ARRAY [NATURAL_64]
			i, j: INTEGER
		do
			create scheduled_words.make_filled (0, 1, 80)

			schedule_words (chunk, scheduled_words)

				--print(HValue)
			create lr.make_filled (0, 1, HValue.count)
			lr.subcopy (HValue, 1, HValue.count, 1)
			from i := 1
			until i > 80
			loop

				round (scheduled_words [i], lr, ks [i])
					--print((i-1).out + "%N")
				from j := 1
				until j > 8
				loop
						--print(lr[j].to_hex_string + "%N")
					j := j + 1
				end
					--print("%N")
				i := i + 1
			end

				--from i := 1
				--until i>lr.count
				--loop
				--    lr[i] := lr[i] + HValue[i]
				--    i := i+1
				--end

			Result := lr
		end

	array_of_int64 (chunk: STRING): ARRAY [NATURAL_64]
		local
			i: INTEGER
			temphex: STRING
			ans: ARRAY [NATURAL_64]
		do
			create ans.make_filled (0, 1, chunk.count // 4)
			from i := 0
			until i >= ans.count
			loop
				temphex := chunk.substring (i * 16 + 1, (i + 1) * 16)

				ans [i + 1] := hextoint (temphex)
				i := i + 1
			end
			Result := ans
		end

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
		end

	calculate_hash (plaintext: STRING): STRING
		local
			i, j, modsize, no_of_chunks: INTEGER
			l_plaintext: STRING
			ith_chunk: ARRAY [NATURAL_64]
			tempHValue, HValue: ARRAY [NATURAL_64]
			digest: STRING
		do
			l_plaintext := plaintext
				--print("original: " + l_plaintext +"%Nsize: "+ l_plaintext.count.out + "%N")

			modsize := l_plaintext.count \\ 256
			if modsize < 224 then
				l_plaintext := add_padding (l_plaintext, 224 - modsize)
			elseif modsize > 224 then
				l_plaintext := add_padding (l_plaintext, 256 - modsize + 224)
			end
				--print("after padding: " + l_plaintext +"%Nsize: "+ l_plaintext.count.out + "%N")

			l_plaintext := add_size (l_plaintext, modsize)
				--print("after size: " + l_plaintext +"%Nsize: "+ l_plaintext.count.out + "%N")

			no_of_chunks := l_plaintext.count // 256
				--print("Number of chunks: " + no_of_chunks.out + "%N")
			HValue := <<a, b, c, d, e, f, g, h>>
				--print("loop 1%N")
			from i := 0
			until i >= no_of_chunks
			loop
				ith_chunk := array_of_int64 (l_plaintext.substring (i * 256 + 1, (i + 1) * 256))

					--print("ith chunk: %N")
					--print(ith_chunk)
				tempHValue := FFunction (ith_chunk, HValue)
					--print("loop 2%N")
				from j := 1
				until j > HValue.count
				loop
						--print(HValue[j].to_hex_string + " " + tempHValue[j].to_hex_string + "%N")
					HValue [j] := HValue [j] + tempHValue [j]
					j := j + 1
				end
				i := i + 1
			end
				--print("loop 3%N")
				--print("%N")
			digest := ""
			from i := 1
			until i > HValue.count
			loop
				digest := digest + HValue [i].to_hex_string
				i := i + 1
			end
			Result := digest
		end

end
