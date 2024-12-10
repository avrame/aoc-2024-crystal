file_id = 0
file_block = true
disk = [] of Int32

input = File.read("input.txt")
input.each_char do |char|
  block_length = char.to_u8
  (1..block_length).each do |b|
    if file_block
      disk << file_id
    else
      disk << -1
    end
  end
  file_block = !file_block
  file_id += 1 if file_block
end

# print_disk(disk)

file_end_idx = get_file_end_idx(disk)
file_id = disk[file_end_idx] if file_end_idx
file_start_idx = nil
until !file_id || file_id == 0
  if file_end_idx
    if file_id
      file_start_idx = disk.index { |block| block == file_id }
      if file_start_idx
        file_length = file_end_idx - file_start_idx + 1
        # puts disk[file_start_idx..file_end_idx]
        space_start_idx = find_space(disk, file_length, file_start_idx)
        if space_start_idx
          disk.fill(file_id, space_start_idx, file_length)
          disk.fill(-1, file_start_idx, file_length)
        end
        file_id -= 1
        file_end_idx = disk.rindex { |block| block == file_id }
        file_id = disk[file_end_idx] if file_end_idx
      end
    end
  else
    break
  end
end

# print_disk(disk)

def get_file_end_idx(disk, offset = nil)
  offset ||= disk.size - 1
  disk.rindex(offset: offset) { |block| block != -1 }
end

def find_space(disk, length, file_start_idx)
  space_end_idx = -1
  while space_end_idx < file_start_idx
    space_start_idx = disk.index(offset: space_end_idx + 1) { |block| block == -1 }
    if space_start_idx
      space_end_idx = space_start_idx
      while disk[space_end_idx + 1]? == -1
        space_end_idx += 1
      end
      if space_end_idx - space_start_idx + 1 >= length && space_end_idx < file_start_idx
        return space_start_idx
      end
    else
      break
    end
  end
  return nil
end

def print_disk(disk)
  disk_str = String.build do |str|
    disk.each do |block|
      str << block
    end
    str << "\n"
  end
  puts disk_str
end

checksum = 0.to_u64
disk.each_with_index do |block, idx|
  if block != -1
    checksum += idx * block
  end
end

puts checksum
