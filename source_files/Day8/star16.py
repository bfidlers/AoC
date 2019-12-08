width = 25
height = 6

f = open("input.txt", "r")
for line in f:
    list_of_values = list(line)

i = 0
matrix_3d = []
while i < len(list_of_values):
    layer = i // (width*height)
    row = (i // width) - layer*height
    if i % (width*height) == 0:
        matrix_3d.append([])
        matrix_3d[layer].append([])
        matrix_3d[layer][row].append(list_of_values[i])
    elif i % width == 0:
        matrix_3d[layer].append([])
        matrix_3d[layer][row].append(list_of_values[i])
    else:
        matrix_3d[layer][row].append(list_of_values[i])
    i += 1

final_values = []
for i in range(width*height):
    row = i // width
    if i % width == 0:
        final_values.append([])
        final_values[row].append("2")
    else:
        final_values[row].append("2")

for layer in matrix_3d:
    for row in range(len(layer)):
        for column in range(len(layer[row])):
            if final_values[row][column] != "0" and final_values[row][column] != "1":
                final_values[row][column] = layer[row][column]

for row in final_values:
    print(row)