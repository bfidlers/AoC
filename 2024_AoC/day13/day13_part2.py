from sympy import symbols, Eq, solve, Integer

file = open("input.txt", "r")

lines = ''.join(file.readlines())
sections = lines.split('\n\n')

def parse_line(line):
  coords = line.split(':')[1].split(',')
  return [int(x.strip()[2:]) for x in coords]


total = 0
for section in sections:
  lines = section.split('\n')
  buttonA = parse_line(lines[0])
  buttonB = parse_line(lines[1])
  prize = parse_line(lines[2])
  
  a, b = symbols('A, B')
  eq1 = Eq(buttonA[0] * a + buttonB[0] * b, 10000000000000 + prize[0])
  eq2 = Eq(buttonA[1] * a + buttonB[1] * b, 10000000000000 + prize[1])
  result = (solve((eq1, eq2), (a, b))) 

  if not (isinstance(result[a], Integer) and isinstance(result[b], Integer)):
    continue
  total += 3 * result[a] + result[b] 

print(total)
