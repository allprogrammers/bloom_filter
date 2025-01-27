class BLOOM_FILTER [G -> HASHABLE]

create
    make

feature

    presence: ARRAY[BOOLEAN]
    max_elements: INTEGER
    number_of_bits: INTEGER
    number_of_hashes: INTEGER


    make (a_max_elements:INTEGER; accuracy: REAL)
    local
        m,k: INTEGER
    do
        -- how many arrays do we need ? 1 supposedly with m booleans
        -- n = max_elements
        -- m = -n*ln(accuracy)/(ln(2)^2) is the number of bits
        -- how many hash algorithms do we need ? k = - ln(accuracy) / ln2
        -- epsilon is accuracy
        -- epsilon simplified = (1-e^(-kn/m))^k (approx)

        max_elements := a_max_elements

        m := (-max_elements*{SINGLE_MATH}.log(accuracy)/({SINGLE_MATH}.log(2)*{SINGLE_MATH}.log(2))).ceiling
        k := (-{SINGLE_MATH}.log(accuracy)/{SINGLE_MATH}.log(2)).ceiling

        create presence.make_filled(False,0,m-1)

        number_of_bits := m
        number_of_hashes := k
        -- initialize k seeds but right now only using 0...k 
    end

    add (item:G)
    local
        index: INTEGER
        i: INTEGER
    do
        from i:=0
        until i>=number_of_hashes
        loop
            index := hash(item,i)
            presence[index] := True
            i := i + 1
        end
    end

    contains (item:G): BOOLEAN
    local
        index: INTEGER
        i: INTEGER
    do
        Result := True
        from i:=0
        until i>=number_of_hashes
        loop
            index := hash(item,i)
            if not presence[index] then
                Result := False
                i := number_of_hashes + 1
            end
            i := i + 1
        end

    end

    hash (item: G; seed: INTEGER): INTEGER
    do
        Result:=0
    end

end