f = open("input.txt", "r")
for line in f:
    list_of_values = [int(x) for x in line.split(",")]

list_of_values[1] = 12
list_of_values[2] = 2

i = 0
while i < len(list_of_values):
    if list_of_values[i] == 99:
        break
    else:
        pos1 = list_of_values[i + 1]
        pos2 = list_of_values[i + 2]
        pos3 = list_of_values[i + 3]

        if list_of_values[i] == 1:
            list_of_values[pos3] = list_of_values[pos1] + list_of_values[pos2]
        elif list_of_values[i] == 2:
            list_of_values[pos3] = list_of_values[pos1] * list_of_values[pos2]
    i += 4

print(list_of_values[0])