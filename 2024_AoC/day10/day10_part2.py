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

def walk(pos, symbol, grid):
  count = 0
  ns = symbol + 1
  if symbol == 9:
    return 1
  for d in dirs:
    npos = (pos[0] + d[0], pos[1] + d[1])
    if not valid_pos(npos, grid):
      continue
    if(grid[npos[1]][npos[0]] == '.'):
      continue
    nnb = int(grid[npos[1]][npos[0]])
    if (nnb == ns):
      count += walk(npos, nnb, grid)
  return count

score = 0
for y, line in enumerate(grid):
  for x, height in enumerate(line):
    if (height == '0'):
      trailheads = walk((x, y), int(height) ,grid)
      score += trailheads

print(score)
