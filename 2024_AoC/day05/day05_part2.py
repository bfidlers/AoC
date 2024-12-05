file = open("input.txt", "r")
s = file.read().split("\n\n")

rules = []
for line in s[0].split("\n"):
  rules.append(line.split("|"))

updates = []
for line in s[1].split("\n"):
  if line:
    updates.append(line.split(","))


def nb_has_right_order(nb, used):
  matches = [l[1] for l in rules if l[0] == nb]
  for m in matches:
    if m in used:
      return False
  return True


def loop(nb, nbs, used):
  matches = [l[0] for l in rules if l[1] == nb]
  if len(matches) == 0:
    used.append(nb)
    return
  for m in matches:
    if m in used:
      continue
    elif m in nbs:
      loop(m, nbs, used)
  used.append(nb)
      

def fix_order(nbs):
  used = []
  for nb in nbs:
    if (nb not in used):
      loop(nb, nbs, used)
  return(used)


def find_middle(nbs):
  length = len(nbs)
  return nbs[length // 2]
  

sum = 0
for update in updates:
  used = set()
  for nb in update:
    if (not nb_has_right_order(nb, used)):
      nbs = fix_order(update)
      sum += int(find_middle(nbs))
      break
    used.add(nb)
  used.clear()

print(sum)
