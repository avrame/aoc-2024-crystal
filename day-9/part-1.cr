file_id = 0
file_block = true
disk = [] of Char | Int32

input = File.read("input.txt")
input.each_char do |char|
  block_length = char.to_u8
  (1..block_length).each do |b|
    if file_block
      disk << file_id
    else
      disk << '.'
    end
  end
  file_block = !file_block
  file_id += 1 if file_block
end

# puts disk

# puts disk
compacted_disk = [] of Int32
disk_copy = disk.clone
end_index = disk_copy.size - 1
disk.each_with_index do |block, idx|
  if block == '.'
    end_block = '.'
    while end_block == '.'
      end_block = disk_copy[end_index]
      end_index -= 1
    end
    # puts "idx=#{idx}, end_index=#{end_index}"
    if idx <= end_index
      compacted_disk << end_block.to_i
    end
  else
    if idx <= end_index
      compacted_disk << block.to_i
    end
  end
  # puts "compacted_disk = #{compacted_disk}"
end

# puts compacted_disk

checksum = compacted_disk.map_with_index do |file_id, idx|
  (idx * file_id).to_u64
end.sum

puts checksum
