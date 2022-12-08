position_mode = 0
immediate_mode = 1
relative_mode = 2

f = open("input.txt", "r")
for line in f:
    list_of_values = [int(x) for x in line.split(",")]

input_value = 1
relative_base = 0

for j in range(1000000):
    list_of_values.append(0)

i = 0
while i < len(list_of_values):
    if list_of_values[i] == 99:
        break
    else:
        instruction = list_of_values[i]
        op_code = instruction % 100

        parameter_mode1 = (instruction % 1000) // 100
        pos1 = list_of_values[i + 1]
        if parameter_mode1 == position_mode:
            parameter1 = list_of_values[pos1]
        elif parameter_mode1 == immediate_mode:
            parameter1 = pos1
        elif parameter_mode1 == relative_mode:
            parameter1 = list_of_values[pos1 + relative_base]
            pos1 += relative_base

        if op_code == 3:
            list_of_values[pos1] = input_value
            i += 2
        elif op_code == 4:
            output_value = parameter1
            print(output_value)
            i += 2
        elif op_code == 9:
            relative_base += parameter1
            i += 2

        else:
            parameter_mode2 = (instruction % 10000) // 1000
            pos2 = list_of_values[i + 2]

            if parameter_mode2 == position_mode:
                parameter2 = list_of_values[pos2]
            elif parameter_mode2 == immediate_mode:
                parameter2 = pos2
            elif parameter_mode2 == relative_mode:
                parameter2 = list_of_values[pos2 + relative_base]

            if op_code == 5:
                if parameter1 != 0:
                    i = parameter2
                else:
                    i += 3
            elif op_code == 6:
                if parameter1 == 0:
                    i = parameter2
                else:
                    i += 3
            else:
                parameter_mode3 = (instruction % 100000) // 10000
                pos3 = list_of_values[i + 3]
                if parameter_mode3 == relative_mode:
                    pos3 += relative_base
                if op_code == 1:
                    list_of_values[pos3] = parameter1 + parameter2
                    i += 4
                elif op_code == 2:
                    list_of_values[pos3] = parameter1 * parameter2
                    i += 4
                elif op_code == 7:
                    if parameter1 < parameter2:
                        list_of_values[pos3] = 1
                    else:
                        list_of_values[pos3] = 0
                    i += 4
                elif op_code == 8:
                    if parameter1 == parameter2:
                        list_of_values[pos3] = 1
                    else:
                        list_of_values[pos3] = 0
                    i += 4