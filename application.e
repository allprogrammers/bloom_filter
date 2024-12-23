class APPLICATION

create
    make

feature
    make
    local
        bloom_filter: BLOOM_FILTER[STRING]
    do
        create bloom_filter.make(10)

        print(bloom_filter.hash("a").out + "%N")
        bloom_filter.add("a")
        
        io.put_string("Might contains k: ")
        io.put_boolean(bloom_filter.mightContains("k"))
        io.put_new_line


    end

end