f = open("input.txt", "r")

disk_map_compressed = f.readline().strip()

used_map = []
free_map = []
used_space = True
file_ID = 0
index = 0
for nb in disk_map_compressed:
  if used_space:
    used_map.append((file_ID, int(nb), index))
    file_ID += 1
  else:
    free_map.append((int(nb), index))
  used_space = not used_space
  index += int(nb)

def find_bigger_or_equal_then(l, v):
  for i, value in enumerate(l):
    if value[0] >= v:
      return i
  return -1

checksum = 0
for i in range(len(used_map) -1, -1, -1):
  (file_ID, length, index) = used_map[i]
  i2 = find_bigger_or_equal_then(free_map, length)
  if i2 >= i or i2 < 0:
    checksum += sum([file_ID * (index + i) for i in range(length)])
  else:
    checksum += sum([file_ID * (free_map[i2][1] + i) for i in range(length)])
    free_map[i2] = (free_map[i2][0] - length, free_map[i2][1] + length)

print(checksum)
