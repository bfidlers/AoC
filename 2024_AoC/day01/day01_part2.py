list1 = []
list2 = []
total = 0

f = open("input.txt", "r")
for line in f:
  t = line.split("   ")
  list1.append(int(t[0]))
  list2.append(int(t[1]))
f.close()

list1.sort()
list2.sort()

for x in list1:
  total += list2.count(x) * x
print(total)
