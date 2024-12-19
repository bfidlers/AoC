from functools import cache

p0, p1 = open("input.txt", "r").read().split("\n\n")
towel_patterns = p0.strip().split(", ")
designs = [line.strip() for line in p1.split("\n") if line.strip()]

@cache
def nb_valid_designs(current, rest):
  if len(rest) == 0:
    return 1 if current == "" else 0
  head, tail = rest[0], rest[1:]
  current += head
  if current in towel_patterns:
    return nb_valid_designs("", tail) + nb_valid_designs(current, tail)
  else:
    return nb_valid_designs(current, tail)

@cache
def nb_valid_designs2(design):
  results = []
  if design == "":
    return 1
  for pattern in towel_patterns:
    if design.startswith(pattern):
      results.append(nb_valid_designs2(design[len(pattern):]))
  return sum([b for b in results if b])

nb_valid_patterns = 0
for design in designs:
  nb_valid_patterns += nb_valid_designs("", design)
  #nb_valid_patterns += nb_valid_designs2(design)

print(nb_valid_patterns)
