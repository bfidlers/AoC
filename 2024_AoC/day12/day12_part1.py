f = open("input.txt", "r")

grid = []
for line in f:
  grid.append(line.strip())

dirs = [(0, -1), (-1, 0), (1, 0), (0, 1)]

def valid_pos(pos, grid):
  if (not 0 <= pos[0] < len(grid[0])):
    return False
  if (not 0 <= pos[1] < len(grid)):
    return False
  return True

def expand(pos, elem, used_pos, grid):
  if grid[pos[1]][pos[0]] != elem:
    return (0, 0)
  if pos in used_pos:
    return (None, None)
  used_pos.add(pos)
  size = 1
  borders = 0
  for d in dirs:
    npos = (pos[0] + d[0], pos[1] + d[1])
    if not valid_pos(npos, grid):
      borders += 1
      continue
    (nsize, n_borders) = expand(npos, elem, used_pos, grid)
    if nsize == None:
      continue
    elif nsize == 0:
      borders += 1
      continue
    else:
      size += nsize
      borders += n_borders
  return (size, borders)


used_pos = set()
total = 0
for y, line in enumerate(grid):
  for x, elem in enumerate(line):
    (amount, borders) = expand((x,y), elem, used_pos, grid)
    if amount != None:
      total += amount * borders

print(total)
