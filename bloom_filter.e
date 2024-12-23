class BLOOM_FILTER [G -> HASHABLE]

create
    make

feature

    presence: ARRAY[BOOLEAN]
        -- The array of booleans that represent the filter.


    make (size:INTEGER)
        -- Create a new bloom filter with the given size and probability of false positives.
    do
        create presence.make_filled(False,0,size-1)
    end

    add (item:G)
        -- Add an item to the filter.
    local
        index: INTEGER
    do
        index := hash(item)
        presence[index] := True
    end

    contains (item:G): BOOLEAN
        -- Check if the item is in the filter.
    local
        index: INTEGER
    do
        index := hash(item)
        Result := presence[index]
    end

    hash (item:G): INTEGER
        -- Hash the item to an index in the filter.
    local
        value: INTEGER
    do
        if item.is_hashable then
            value := item.hash_code \\ presence.count
        end
        Result := value
    end

end