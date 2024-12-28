f = open("input.txt", "r")

def next_secret_number(nb):
  n1 = ((nb * 64) ^ nb) % 16777216
  n2 = ((n1 // 32) ^ n1) % 16777216
  n3 = ((n2 * 2048) ^ n2) % 16777216
  return n3

total = 0
for l in f:
  nb = int(l)
  for i in range(2000):
    nb = next_secret_number(nb)
  total += nb

print(total)
