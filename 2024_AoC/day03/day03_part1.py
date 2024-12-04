import re

total = 0

f = open("input.txt", "r")
for line in f:
  matches = re.findall(r"mul\(\d{1,3},\d{1,3}\)", line)

  for m in matches:
    stripped = re.sub("[mul()]", "", m)
    split = stripped.split(",")
    total += int(split[0]) * int(split[1])

print(total)
  
