grid = []

f = open("input.txt", "r")
for line in f:
  grid.append(line.strip())

dirs = [
  [1, -1],
  [1, 1]
]

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

def check_diagonal(grid, pos, d):
  left = [pos[0] - d[0], pos[1] - d[1]]
  right = [pos[0] + d[0], pos[1] + d[1]]
  if (not valid_position(left, grid)):
    return False
  if (not valid_position(right, grid)):
    return False
  c_left = grid[left[1]][left[0]]
  c_right = grid[right[1]][right[0]]
  if (c_left == "M" and c_right == "S"):
    return True
  if (c_left == "S" and c_right == "M"):
    return True
  return False

amount = 0
for x in range(len(grid[0])):
  for y in range(len(grid)):
    character = grid[y][x]
    if (character == "A"):
      frst_d = check_diagonal(grid, [x, y], dirs[0])
      snd_d = check_diagonal(grid, [x, y], dirs[1])
      if (frst_d and snd_d):
        amount += 1

print(amount)

