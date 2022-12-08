sum = 0

f = open("input.txt", "r")
for x in f:
    x2 = int(x)
    x2 = x2//3
    x2 -= 2
    sum += x2

print(sum)
