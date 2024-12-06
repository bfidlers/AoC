import copy

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
  if grid[pos[1]][pos[0]] == '#' or grid[pos[1]][pos[0]] == 'O':
    return True
  return False


def same_path(npos, d, grid):
  if out_of_bounds(npos, grid):
    return False
  next_char = grid[npos[1]][npos[0]]
  if next_char == d:
    return True
  return False


def step(pos, d, grid):
  next_pos = next_position(pos, d)
  if out_of_bounds(next_pos, grid):
    return None, None
  if obstructed(next_pos, grid):
    return pos, next_dir(d)

  grid[next_pos[1]] = grid[next_pos[1]][:next_pos[0]] + d + grid[next_pos[1]][next_pos[0] + 1:]
  return next_pos, d


def check_if_loops(pos, d, tmp_grid):
  direction = d
  while True:
    npos = next_position(pos, direction)
    if same_path(npos, direction, tmp_grid):
      return True
    pos, direction = step(pos, direction, tmp_grid)
    if pos == None:
      return False


def place_obstacle(npos, grid):
  if out_of_bounds(npos, grid):
    return False
  if grid[npos[1]][npos[0]] != '.':
    return False
  grid[npos[1]] = grid[npos[1]][:npos[0]] + 'O' + grid[npos[1]][npos[0] + 1:]
  return True


d = '^'
possible_obstacles = set()
while True:
  tmp_grid = grid.copy() 
  tmp_pos = pos.copy() 
  next_pos = next_position(tmp_pos, d)
  if place_obstacle(next_pos, tmp_grid):
    if check_if_loops(tmp_pos, d, tmp_grid):
      string_pos = "(" + str(next_pos[0]) + ", " + str(next_pos[1])
      possible_obstacles.add(string_pos)
  pos, d = step(pos, d, grid)
  if pos == None:
    break
  
print(len(possible_obstacles))

