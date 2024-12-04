grid = []

f = open("input.txt", "r")
for line in f:
  grid.append(line.strip())

directions = [
  [-1, -1],
  [-1, 0],
  [-1, 1],
  [0, -1],
  [0, 1],
  [1, -1],
  [1, 0],
  [1, 1]
]

amount = 0

def valid_position(pos, grid):
  if (pos[1] < 0):
    return False
  if (pos[0] < 0):
    return False
  if (pos[1] >= len(grid)):
    return False
  if (pos[0] >= len(grid[0])):
    return False
  return True

def step(grid, pos, d):
  next_pos = [pos[0] + d[0], pos[1] + d[1]]
  if (not valid_position(next_pos, grid)):
    return None
  c0 = grid[pos[1]][pos[0]]
  c1 = grid[next_pos[1]][next_pos[0]]
  if (c0 == "X" and c1 == "M"):
    return next_pos
  if (c0 == "M" and c1 == "A"):
    return next_pos
  if (c0 == "A" and c1 == "S"):
    global amount
    amount += 1
  return None

def move(grid, pos, d):
  next_pos = step(grid, pos, d)
  if (not next_pos):
    return
  move(grid, next_pos, d)

for x in range(len(grid[0])):
  for y in range(len(grid)):
    for d in directions:
      character = grid[y][x]
      if (character == "X"):
        move(grid, [x, y], d)

print(amount)

