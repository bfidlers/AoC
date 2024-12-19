f = open("input.txt", "r")


def out_of_bounds(pos, grid):
  if (pos[0] < 0):
    return True
  if (pos[1] < 0):
    return True
  if (pos[0] >= len(grid[0])):
    return True
  if (pos[1] >= len(grid)):
    return True
  return False


def add_extra_points(pos, diff, grid, points):
  p = (pos[0] + diff[0], pos[1] + diff[1])
  if not out_of_bounds(p, grid):
    points.add(p)
    add_extra_points(p, diff, grid, points)
  else:
    return


grid = []
for x in f:
  grid.append(x.strip())

antennas = {}
for y in range(len(grid)):
  for x in range(len(grid[0])):
    symbol = grid[y][x]
    if symbol != '.':
      if symbol in antennas:
        positions = antennas[symbol]
        positions.append((x,y))
        antennas.update({symbol: positions})
      else:
        antennas.update({symbol: [(x,y)]})

antinodes = set()
for symbol, coords in antennas.items():
  for i1 in range(len(coords)):
    for i2 in range(i1 + 1, len(coords)):
      antinodes.add(coords[i1])
      antinodes.add(coords[i2])
      diff = (coords[i1][0] - coords[i2][0], coords[i1][1] - coords[i2][1])
      add_extra_points(coords[i1], diff, grid, antinodes)
      add_extra_points(coords[i2], (-diff[0], -diff[1]), grid, antinodes)

print(len(antinodes))