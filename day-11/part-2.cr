input_file = ARGV[0]
blink_count = ARGV[1].to_u64

input = File.read(input_file)
stones = input.split(" ").map do |stone_str|
  stone_str.to_u64
end

stone_count = 0.to_u64
memo = Hash(Tuple(UInt64, UInt64), UInt64).new
stones.each do |stone|
  stone_count += count_stones(stone, blink_count, memo)
end
puts stone_count

def count_stones(stone, blinks_left, memo) : UInt64
  return 1.to_u64 if blinks_left == 0

  if memo.has_key?({stone, blinks_left})
    return memo[{stone, blinks_left}]
  end

  if stone == 0
    memo[{stone, blinks_left}] = count_stones(1.to_u64, blinks_left - 1, memo)
  elsif stone.to_s.size.even?
    stone_str = stone.to_s
    halfway = (stone_str.size / 2).to_u64
    first_half = stone_str[...halfway].to_u64
    second_half = stone_str[halfway..].to_u64
    count = 0.to_u64
    count += count_stones(first_half, blinks_left - 1, memo)
    count += count_stones(second_half, blinks_left - 1, memo)
    memo[{stone, blinks_left}] = count
  else
    memo[{stone, blinks_left}] = count_stones(stone * 2024, blinks_left - 1, memo)
  end

  return memo[{stone, blinks_left}]
end
