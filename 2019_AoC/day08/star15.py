width = 25
height = 6

f = open("input.txt", "r")
for line in f:
    list_of_values = list(line)

i = 0
matrix_2d = []
while i < len(list_of_values):
    layer = i // (width*height)
    if i % (width*height) == 0:
        matrix_2d.append([])
        matrix_2d[layer].append(list_of_values[i])
    else:
        matrix_2d[layer].append(list_of_values[i])
    i += 1

list_of_zero_values = []
for layer in matrix_2d:
    nb_of_zeros = 0
    for elem in layer:
        if elem == '0':
            nb_of_zeros += 1
    list_of_zero_values.append(nb_of_zeros)

fewest_zeros = width * height
for i in range(len(list_of_zero_values)):
    if list_of_zero_values[i] < fewest_zeros:
        fewest_zeros = list_of_zero_values[i]
        layer_fewest_zeros = i

nb_of_ones = 0
nb_of_twos = 0
for element in matrix_2d[layer_fewest_zeros]:
    if element == "1":
        nb_of_ones += 1
    elif element == "2":
        nb_of_twos += 1

print(nb_of_ones * nb_of_twos)
