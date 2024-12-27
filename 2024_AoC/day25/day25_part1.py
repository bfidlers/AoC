sections = open("input.txt", "r").read().split("\n\n")

locks = []
keys = []
max_length = len(sections[0].split("\n")) - 2
for section in sections:
  lines = section.strip().split("\n")
  pin_heights = []
  for i in range(len(lines[0])):
    height = 0
    for j in range(len(lines)):
      if lines[j][i] == '#':
        height += 1
    pin_heights.append(height - 1)

  if lines[0] == len(lines[0]) * '#':
    locks.append(pin_heights)
  else:
    keys.append(pin_heights)

def does_fit(key, lock, size):
  for i in range(len(key)):
    if key[i] + lock[i] > size:
      return False
  return True

total = 0
for key in keys:
  for lock in locks:
    total += does_fit(key, lock, max_length)

print(total)
