import queue

f = open("input.txt", "r")

lines = ''.join(f.readlines())
paragraphs = lines.split('\n\n')

registers = [int(row.split(':')[1]) for row in paragraphs[0].split('\n')]

rA, rB, rC = registers[0], registers[1], registers[2]
instructions = [int(x) for x in paragraphs[1].split(':')[1].split(',')]

ip = 0

def combo_operand(operand):
  global rA, rB, rC
  if 0 <= operand <= 3:
    return operand
  if operand == 4:
    return rA
  if operand == 5:
    return rB
  if operand == 6:
    return rC
  if operand == 7:
    print("Invalid program!")

def execute(opcode, operand, output):
  global ip, rA, rB, rC
  ip += 2
  match opcode:
    case 0:
      rA = rA >> combo_operand(operand)
    case 1:
      rB = rB ^ operand
    case 2:
      rB = combo_operand(operand) % 8
    case 3:
      if rA != 0:
        ip = operand
    case 4:
      rB = rB ^ rC
    case 5:
      output.append(combo_operand(operand) % 8)
    case 6:
      rB = rA >> combo_operand(operand)
    case 7:
      rC = rA >> combo_operand(operand)

# Let's compute from the back to the front. 
# Our A in the end needs to be 0
# We know every loop A gets shifted 3 bits back (eqv to // 8)
# So we can start with A being zero multiplying this by 8 and testing which byte between 0 and 8 prints the correct output.
# Repeat as long as we don't have the full output.
to_check = queue.Queue()
to_check.put((instructions[-1], len(instructions) - 1))
results = []
while not to_check.empty():
  iA, i = to_check.get()
  for k in range(8):
    output = []
    ip = 0
    rA = iA * 8 + k
    rB, rC = registers[1], registers[2]
    while ip < len(instructions):
      execute(instructions[ip], instructions[ip + 1], output)
    if output[0] == instructions[i]:
      if i == 0:
        results.append(iA * 8 + k)
      else:
      # !we are not sure this is the only one, need to check others as well!!
        to_check.put((iA * 8 + k, i - 1))

print(min(results))
