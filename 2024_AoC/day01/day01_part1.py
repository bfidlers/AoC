list1 = []
list2 = []
sum = 0

f = open("input.txt", "r")
for line in f:
  t = line.split("   ")
  list1.append(int(t[0]))
  list2.append(int(t[1]))
f.close()

list1.sort()
list2.sort()

for i in range(len(list1)):
  diff = abs(list2[i] - list1[i])
  sum += diff
print(sum)
