def safe(nbs):
  incr = True
  if (nbs[1] < nbs[0]):
    incr = False
  for i in range(len(parsed) - 1):
    diff = nbs[i+1] - nbs[i]
    if (incr and diff >=1 and diff <=3):
      continue
    elif (not incr and diff <=-1 and diff >=-3):
      continue
    else:
      return False
  return True


f = open("input.txt", "r")
total_safe = 0

for line in f:
  parsed = line.split(" ")
  nbs = map(int, parsed)
  total_safe += safe(list(nbs))
print(total_safe)
