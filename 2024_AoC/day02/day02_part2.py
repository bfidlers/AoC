def safe(nbs, tolerated = False):
  if len(nbs) < 2:
    return False
  incr = True
  if (nbs[1] < nbs[0]):
    incr = False
  for i in range(len(nbs) - 1):
    diff = nbs[i+1] - nbs[i]
    if (incr and diff >=1 and diff <=3):
      continue
    elif (not incr and diff <=-1 and diff >=-3):
      continue
    elif not tolerated:
      tolerated = True
      return tolerate(nbs)
    else:
      return False
  return True


def tolerate(nbs):
  incr = True
  tolerated = False
  for i in range(len(parsed)):
    og_list = nbs.copy()
    og_list.pop(i)
    safe_list = safe(og_list, True)
    if safe_list:
      print(og_list)
      return True
  return False


f = open("input.txt", "r")
total_safe = 0

for line in f:
  parsed = line.split(" ")
  nbs = map(int, parsed)
  total_safe += safe(list(nbs))
print(total_safe)
