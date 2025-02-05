class BLOOM_FILTER [G -> HASHABLE]

create
	make

feature {NONE}

	presence: ARRAY [BOOLEAN]
	number_of_hashes: INTEGER

	hash (item: G; seed: INTEGER): INTEGER
		-- Hash the item to a number between zero and size of presence array. 
		-- Ideally outputs different results for different pairs of (item, seed).
		local
			osha: SHA512 -- hash class to use
		do
			create osha.make
			Result := osha.calculate_hash ((item.hash_code + seed).to_hex_string).hash_code \\ presence.count
		end

	make (n: INTEGER; eps: REAL)
			-- Initializes the filter using
			-- n: Maximum number of items to account for
			-- eps: Maximum probability of false positives to ensure
		local
			-- m = -n*ln(eps)/(ln(2)^2): number of bits (BOOLEANS) to use for the filter
			-- k = - ln(eps) / ln2: number of hashes to use per item
			m, k: INTEGER
		do
			m := (- n * {SINGLE_MATH}.log (eps) / ({SINGLE_MATH}.log (2) * {SINGLE_MATH}.log (2))).ceiling
			k := (- {SINGLE_MATH}.log (eps) / {SINGLE_MATH}.log (2)).ceiling

			create presence.make_filled (False, 0, m - 1)

			number_of_hashes := k

			print ("Making with m=" + m.out + " n=" + n.out + " k=" + k.out + "%N")
		end

feature {ANY}

	add (item: G)
			-- Add the item to the filter.
		local
			index: INTEGER
			i: INTEGER
		do
			from i := 0
			until i >= number_of_hashes
			loop
				index := hash (item, i)
				presence [index] := True
				i := i + 1
			end
		end

	contains (item: G): BOOLEAN
			-- Check if the filter contains the item.
		local
			index: INTEGER
			i: INTEGER
		do
			Result := True
			from i := 0
			until i >= number_of_hashes
			loop
				index := hash (item, i)
				if not presence [index] then
					Result := False
					i := number_of_hashes + 1
				end
				i := i + 1
			end

		end

end
