position_mode = 0
immediate_mode = 1

f = open("input.txt", "r")
for line in f:
    list_of_values = [int(x) for x in line.split(",")]

input_value = 1

i = 0
while i < len(list_of_values):
    if list_of_values[i] == 99:
        break
    else:
        instruction = list_of_values[i]
        opcode = instruction % 100

        parameter_mode1 = (instruction % 1000) // 100
        pos1 = list_of_values[i + 1]
        if parameter_mode1 == position_mode:
            parameter1 = list_of_values[pos1]
        else:
            parameter1 = pos1

        if opcode == 3:
            list_of_values[pos1] = input_value
            i += 2
        elif opcode == 4:
            output_value = parameter1
            print(output_value)
            i += 2

        else:
            parameter_mode2 = (instruction % 10000) // 1000
            pos2 = list_of_values[i + 2]

            if parameter_mode2 == position_mode:
                parameter2 = list_of_values[pos2]
            else:
                parameter2 = pos2

            parameter_mode3 = (instruction % 100000) // 10000
            pos3 = list_of_values[i + 3]
            if opcode == 1:
                list_of_values[pos3] = parameter1 + parameter2
                i += 4
            elif opcode == 2:
                list_of_values[pos3] = parameter1 * parameter2
                i += 4
