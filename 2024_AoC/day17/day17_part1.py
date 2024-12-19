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
      rA = rA // (2 ** combo_operand(operand))
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
      rB = rA // (2 ** combo_operand(operand))
    case 7:
      rC = rA // (2 ** combo_operand(operand))

output = []
while ip < len(instructions):
  execute(instructions[ip], instructions[ip + 1], output)
  
print(",".join(str(x) for x in output))
