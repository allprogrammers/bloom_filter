class BLOOM_FILTER [G -> HASHABLE]

create
	make

feature

	presence: ARRAY [BOOLEAN]
	max_elements: INTEGER
	number_of_bits: INTEGER
	number_of_hashes: INTEGER

	make (a_max_elements: INTEGER; eps: REAL)
		local
			m, k: INTEGER
		do
				-- how many arrays do we need ? 1 supposedly with m booleans
				-- n = max_elements
				-- m = -n*ln(eps)/(ln(2)^2) is the number of bits
				-- how many hash algorithms do we need ? k = - ln(eps) / ln2
				-- epsilon simplified = (1-e^(-kn/m))^k (approx)
			max_elements := a_max_elements

			m := (- max_elements * {SINGLE_MATH}.log (eps) / ({SINGLE_MATH}.log (2) * {SINGLE_MATH}.log (2))).ceiling
			k := (- {SINGLE_MATH}.log (eps) / {SINGLE_MATH}.log (2)).ceiling

			create presence.make_filled (False, 0, m - 1)

			number_of_bits := m
			number_of_hashes := k

			print ("Making with m=" + m.out + " n=" + max_elements.out + " k=" + k.out + "%N")
				-- initialize k seeds but right now only using 0...k
		end

	add (item: G)
		local
			index: INTEGER
			i: INTEGER
		do
			from i := 0
			until i >= number_of_hashes
			loop
				index := hash (item, i)
				presence [index] := True
					--print("setted "+index.out+" to true%N")
				i := i + 1
			end
		end

	contains (item: G): BOOLEAN
		local
			index: INTEGER
			i: INTEGER
		do
			Result := True
			from i := 0
			until i >= number_of_hashes
			loop
				index := hash (item, i)
					--print("got index "+index.out+" %N")
				if not presence [index] then
					Result := False
					i := number_of_hashes + 1
						--print(index.out+" is false%N")
				end
				i := i + 1
			end

		end

	hash (item: G; seed: INTEGER): INTEGER
		local
			osha: SHA512
		do
			create osha.make
			Result := osha.calculate_hash ((item.hash_code + seed).to_hex_string).hash_code \\ number_of_bits

				--print(Result.out+"%N")

		end

end
