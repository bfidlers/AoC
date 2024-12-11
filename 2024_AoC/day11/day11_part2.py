f = open("input.txt", "r")

line = f.readline().strip()
stones = [int(stone) for stone in line.split(" ")]


def add(nb, amount, nbs):
  if nb in nbs:
    nbs[nb] += amount
  else:
    nbs[nb] = amount


def iteration(stones):
  new_stones = {}
  for stone, amount in stones.items():
    if stone == 0:
      add(1, amount, new_stones)
    elif len(str(stone)) % 2 == 0:
      sep = int("1" + "0" * (len(str(stone)) // 2))
      add(stone // sep, amount, new_stones)
      add(stone % sep, amount, new_stones)
    else:
      add(stone * 2024, amount, new_stones)
  return new_stones


def total(stones):
  total = 0
  for value in stones.values():
    total += value
  return total

  
stone_set = {}
for stone in stones:
  add(stone, 1, stone_set)
  
for _ in range(75):
  stone_set = iteration(stone_set)
print(total(stone_set))
