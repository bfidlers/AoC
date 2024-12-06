f = open("input.txt", "r")

grid = []
pos = []

y = 0
for line in f:
  if '^' in line:
    pos = [line.index('^'), y]
  grid.append(line.strip())
  y += 1

grid[pos[1]] = grid[pos[1]][:pos[0]] + 'X' + grid[pos[1]][pos[0] + 1:]


def next_position(pos, c):
  match c:
    case '^':
      return [pos[0], pos[1] - 1]
    case '>':
      return [pos[0] + 1, pos[1]]
    case 'v':
      return [pos[0], pos[1] + 1]
    case '<':
      return [pos[0] - 1, pos[1]]


def next_dir(c):
  match c:
    case '^':
      return '>'
    case '>':
      return 'v'
    case 'v':
      return '<'
    case '<':
      return '^'


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


def obstructed(pos, grid):
  if grid[pos[1]][pos[0]] == '#':
    return True
  return False


def step(pos, d, grid):
  next_pos = next_position(pos, d)
  if out_of_bounds(next_pos, grid):
    return None, None
  if obstructed(next_pos, grid):
    return pos, next_dir(d)

  grid[next_pos[1]] = grid[next_pos[1]][:next_pos[0]] + 'X' + grid[next_pos[1]][next_pos[0] + 1:]
  return next_pos, d


d = '^'
while True:
  pos, d = step(pos, d, grid)
  if pos == None:
    break
  
count = 0
for line in grid:
  count += line.count('X')
print(count)
