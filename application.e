class APPLICATION

create
	make

feature
	make
		local
			bloom_filter: BLOOM_FILTER [INTEGER]
			prob: REAL
			i, j: INTEGER
			c, fp, fn, test_cases, positives: INTEGER
		do

			test_cases := 100
			positives := 50

			from i := 1
			until i > 9
			loop
				prob := (i * 0.1).truncated_to_real
				c := 0
				fp := 0
				fn := 0
				create bloom_filter.make (100, prob)
				from j := 1
				until j > positives
				loop
					bloom_filter.add (j)
					j := j + 1
				end

				from j := 1
				until j > positives
				loop
					if bloom_filter.contains (j) then
						c := c + 1
					else
						fn := fn + 1
					end
					j := j + 1
				end

				from j := positives + 1
				until j > test_cases
				loop
					if bloom_filter.contains (j) then
						fp := fp + 1
					else
						c := c + 1
					end
					j := j + 1
				end

				print ("test cases: " + test_cases.out + " correct: " + c.out + " false positives: " + fp.out + " false negatives: " + fn.out + " prob: " + prob.out + " actual prob: " + (fp / positives).out + "%N")
				i := i + 1
			end

		end

end
