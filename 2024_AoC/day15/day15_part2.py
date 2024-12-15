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

def canPush(pos, d, grid):
  c = grid[pos[1]][pos[0]]
  if c == '#':
    return False
  elif c == '.':
    return True
  elif (d == '>' or d == '<') and (c == '[' or c == ']'):
    return canPush(next_position(pos, d), d, grid) 
  elif c == '[':
    return canPush(next_position(pos, d), d, grid) and canPush(next_position((pos[0] + 1, pos[1]), d), d, grid) 
  elif c == ']':
    return canPush(next_position(pos, d), d, grid) and canPush(next_position((pos[0] - 1, pos[1]), d), d, grid) 

def switch(p1, p2, grid):
  grid[p1[1]][p1[0]], grid[p2[1]][p2[0]] = grid[p2[1]][p2[0]], grid[p1[1]][p1[0]]

def push(pos, d, grid):
  npos = next_position(pos, d)
  nc = grid[npos[1]][npos[0]]
  if nc == '#':
    print("HELP: this should not happen")
  elif nc == '.':
    switch(npos, pos, grid)
  elif (d == '>' or d == '<') and (nc == '[' or nc == ']'):
    push(npos, d, grid)
    switch(npos, pos, grid)
  elif nc == '[':
    push(npos, d, grid)
    push((npos[0] + 1, npos[1]), d, grid)
    switch(npos, pos, grid)
  elif nc == ']':
    push(npos, d, grid)
    push((npos[0] - 1, npos[1]), d, grid)
    switch(npos, pos, grid)
    
def pushObstacle(pos, d, grid):
  npos = next_position(pos, d)
  if canPush(npos, d, grid):
    push(pos, d, grid)
    return True
  return False

def walk(pos, d, grid):
  npos = next_position(pos, d)
  nc = grid[npos[1]][npos[0]]
  if nc == '#':
    return pos
  if nc == '.':
    switch(pos, npos, grid)
    return npos
  if nc == '[' or nc == ']':
    if pushObstacle(pos, d, grid):
      return npos
  return pos

def getSumGPSCoordinates(grid):
  total = 0
  for y, row in enumerate(grid):
    for x, c in enumerate(row):
      if c == '[':
        total += 100 * y + x
  return total

f = open("input.txt", "r")

lines = ''.join(f.readlines())
paragraphs = lines.split('\n\n')

grid = []
start = (0, 0)
for row, line in enumerate(paragraphs[0].split('\n')):
  new_line = []
  for c in line:
    if c == '#' or c == '.':
      new_line.append(c)
      new_line.append(c)
    if c == 'O':
      new_line.append('[')
      new_line.append(']')
    if c == '@':
      new_line.append('@')
      new_line.append('.')
  if '@' in line:
    start = (new_line.index('@'), row)
  grid.append(new_line)

instructions = ''.join(paragraphs[1].split('\n'))

pos = start
for instr in instructions:
  pos = walk(pos, instr, grid)
  #print_matrix(grid)

print(getSumGPSCoordinates(grid))
