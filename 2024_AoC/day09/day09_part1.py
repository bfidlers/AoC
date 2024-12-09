f = open("input.txt", "r")

disk_map_compressed = f.readline().strip()

disk_map = []
used_space = True
file_ID = 0
for nb in disk_map_compressed:
  if used_space:
    disk_map += [file_ID] * int(nb)
    file_ID += 1
  else:
    disk_map += ['.'] * int(nb)
  used_space = not used_space

for i in range(len(disk_map) -1, -1, -1):
  if disk_map[i] == '.':
    continue
  first = disk_map.index('.')
  if i < first:
    continue
  disk_map[i], disk_map[first] = disk_map[first], disk_map[i]

checksum = 0
for i in range(len(disk_map)):
  if disk_map[i] == '.':
    break
  checksum += disk_map[i] * i

print(checksum)
