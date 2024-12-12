input_file = ARGV[0]
blink_count = ARGV[1].to_i32

input = File.read(input_file)
stones = input.split(" ")

blink_count.times do |blink_num|
    puts "blink #{blink_num + 1}"
    next_stones = [] of String
    stones.each do |stone|
        if stone == "0"
            next_stones << "1"
        elsif stone.size.even?
            halfway = (stone.size / 2).to_i32
            first_half = stone[...halfway]
            second_half = stone[halfway..].to_i32.to_s
            next_stones << first_half
            next_stones << second_half
        else
            next_stones << (stone.to_i64 * 2024).to_s
        end
    end
    stones = next_stones
    # puts stones
end

puts stones.size