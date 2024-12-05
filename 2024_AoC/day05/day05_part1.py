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


def find_middle(nbs):
  length = len(nbs)
  return nbs[length // 2]
  

sum = 0
for update in updates:
  if not update:
    break
  used = set()
  correct_order = True
  for nb in update:
    if (not nb_has_right_order(nb, used)):
      correct_order = False
      break
    used.add(nb)
  if correct_order:
    sum += int(find_middle(update))
  used.clear()

print(sum)
