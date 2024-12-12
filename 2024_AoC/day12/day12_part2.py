f = open("input.txt", "r")

grid = []
for line in f:
  grid.append(line.strip())

dirs = [(0, -1), (-1, 0), (1, 0), (0, 1)]

def corner_neighbours(neighbours):
  diff = (neighbours[0][0] - neighbours[1][0], neighbours[0][1] - neighbours[1][1])
  if abs(diff[0]) == 2 or abs(diff[1]) == 2:
    return False
  return True

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
  other_neighbours = []
  correct_dirs = []
  for d in dirs:
    npos = (pos[0] + d[0], pos[1] + d[1])
    if not valid_pos(npos, grid):
      other_neighbours.append(npos)
      continue
    (nsize, n_borders) = expand(npos, elem, used_pos, grid)
    if nsize == None:
      correct_dirs.append(d)
      continue
    elif nsize == 0:
      other_neighbours.append(npos)
      continue
    else:
      correct_dirs.append(d)
      size += nsize
      borders += n_borders
  if len(other_neighbours) == 4:
    borders += 4
  elif len(other_neighbours) == 3:
    borders += 2
  elif len(other_neighbours) == 2 and corner_neighbours(other_neighbours):
    borders += 1
  for i1, d1 in enumerate(correct_dirs):
    for d2 in correct_dirs[i1+1:]:
      d = (d1[0] + d2[0], d1[1] + d2[1])
      npos = (pos[0] + d[0], pos[1] + d[1])
      if not valid_pos(npos, grid):
        continue
      if grid[npos[1]][npos[0]] != elem:
        borders += 1
  return (size, borders)


used_pos = set()
total = 0
for y, line in enumerate(grid):
  for x, elem in enumerate(line):
    (amount, borders) = expand((x,y), elem, used_pos, grid)
    if amount != None:
      total += amount * borders

print(total)
