f = open("input.txt", "r")

line = f.readline().strip()
stones = [int(stone) for stone in line.split(" ")]

def iteration(stones):
  new_stones = []
  for stone in stones:
    if stone == 0:
      new_stones.append(1)
    elif len(str(stone)) % 2 == 0:
      sep = int("1" + "0" * (len(str(stone)) // 2))
      new_stones.append(stone // sep)
      new_stones.append(stone % sep)
    else:
      new_stones.append(stone * 2024)
  return new_stones
  

for _ in range(25):
  stones = iteration(stones)
print(len(stones))
