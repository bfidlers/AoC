from functools import cache

p0, p1 = open("input.txt", "r").read().split("\n\n")
towel_patterns = p0.strip().split(", ")
designs = [line.strip() for line in p1.split("\n") if line.strip()]

@cache
def valid_design(current, rest):
  if len(rest) == 0:
    return True if current == "" else False
  head, tail = rest[0], rest[1:]
  current += head
  if current in towel_patterns:
    return valid_design("", tail) or valid_design(current, tail)
  else:
    return valid_design(current, tail)

@cache
def valid_design2(design):
  results = []
  if design == "":
    return True
  for pattern in towel_patterns:
    if design.startswith(pattern):
      results.append(valid_design2(design[len(pattern):]))
  return any(results)

valid_patterns = 0
for design in designs:
  if valid_design("", design):
  #if valid_design2(design):
    valid_patterns += 1

print(valid_patterns)
