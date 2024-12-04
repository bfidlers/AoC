import re

def compute(line):
  matches = re.findall(r"mul\(\d{1,3},\d{1,3}\)", line)

  value = 0
  for m in matches:
    stripped = re.sub("[mul()]", "", m)
    split = stripped.split(",")
    value += int(split[0]) * int(split[1])

  return value

total = 0
f = open("input.txt", "r")
enabled = True
for line in f:
  does = re.findall(r"do\(\)|don't\(\)", line)
  subsets = re.split(r"do\(\)|don't\(\)", line)

  for i in range(len(subsets)):
    if enabled:
      amount = compute(subsets[i])
      total += amount
    if i == len(subsets) - 1:
      break
    if does[i] == "do()":
      enabled = True
    else:
      enabled = False

print(total)

