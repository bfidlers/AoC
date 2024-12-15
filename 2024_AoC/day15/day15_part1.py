def print_matrix(matrix):
  for row in matrix:
    print(''.join(row))

def next_position(pos, c):
  match c:
    case '>':
      return (pos[0] + 1, pos[1])
    case '<':
      return (pos[0] - 1, pos[1])
    case 'v':
      return (pos[0], pos[1] + 1)
    case '^':
      return (pos[0], pos[1] - 1)

def pushObstacle(og_pos, pos, c, grid):
  npos = next_position(pos, c)
  nc = grid[npos[1]][npos[0]]
  if nc == '#':
    return
  if nc == '.':
    grid[npos[1]][npos[0]] = 'O'
    grid[og_pos[1]][og_pos[0]] = '.'
    return
  if nc == 'O':
    pushObstacle(og_pos, npos, c, grid)

def walk(pos, c, grid):
  npos = next_position(pos, c)
  nc = grid[npos[1]][npos[0]]
  if nc == '#':
    return pos
  if nc == '.':
    grid[npos[1]][npos[0]] = '@'
    grid[pos[1]][pos[0]] = '.'
    return npos
  if nc == 'O':
    pushObstacle(npos, npos, c, grid)
    if grid[npos[1]][npos[0]] == '.':
      grid[npos[1]][npos[0]] = '@'
      grid[pos[1]][pos[0]] = '.'
      return npos
  return pos

def getSumGPSCoordinates(grid):
  total = 0
  for y, row in enumerate(grid):
    for x, c in enumerate(row):
      if c == 'O':
        total += 100 * y + x
  return total

f = open("input.txt", "r")

lines = ''.join(f.readlines())
paragraphs = lines.split('\n\n')

grid = []
start = (0, 0)
for row, line in enumerate(paragraphs[0].split('\n')):
  if '@' in line:
    start = (line.index('@'), row)
  grid.append(list(line))

instructions = ''.join(paragraphs[1].split('\n'))

pos = start
for instr in instructions:
  pos = walk(pos, instr, grid)
  #print_matrix(grid)

print(getSumGPSCoordinates(grid))
