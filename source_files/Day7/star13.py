import copy
from itertools import permutations

position_mode = 0
immediate_mode = 1

possible_phases = [0, 1, 2, 3, 4]
possible_permutations = list(permutations(possible_phases))

f = open("input.txt", "r")
for line in f:
    list_of_values = [int(x) for x in line.split(",")]


def intcode(first_input, second_input):
    current_list = copy.deepcopy(list_of_values)
    first_input_used = False

    i = 0
    while i < len(list_of_values):
        if current_list[i] == 99:
            break
        else:
            instruction = current_list[i]
            opcode = instruction % 100

            parameter_mode1 = (instruction % 1000) // 100
            pos1 = current_list[i + 1]
            if parameter_mode1 == position_mode:
                parameter1 = current_list[pos1]
            else:
                parameter1 = pos1

            if opcode == 3:
                if first_input_used:
                    current_list[pos1] = second_input
                else:
                    current_list[pos1] = first_input
                    first_input_used = True
                i += 2
            elif opcode == 4:
                output_value = parameter1
                return output_value
                i += 2

            else:
                parameter_mode2 = (instruction % 10000) // 1000
                pos2 = current_list[i + 2]

                if parameter_mode2 == position_mode:
                    parameter2 = current_list[pos2]
                else:
                    parameter2 = pos2

                if opcode == 5:
                    if parameter1 != 0:
                        i = parameter2
                    else:
                        i += 3
                elif opcode == 6:
                    if parameter1 == 0:
                        i = parameter2
                    else:
                        i += 3
                else:
                    parameter_mode3 = (instruction % 100000) // 10000
                    pos3 = current_list[i + 3]
                    if opcode == 1:
                        current_list[pos3] = parameter1 + parameter2
                        i += 4
                    elif opcode == 2:
                        current_list[pos3] = parameter1 * parameter2
                        i += 4
                    elif opcode == 7:
                        if parameter1 < parameter2:
                            current_list[pos3] = 1
                        else:
                            current_list[pos3] = 0
                        i += 4
                    elif opcode == 8:
                        if parameter1 == parameter2:
                            current_list[pos3] = 1
                        else:
                            current_list[pos3] = 0
                        i += 4
    return output_value


max_thruster_list = []
max_thruster_signal = 0
for phase_combination in possible_permutations:
    input_signal = 0
    for i in range(len(possible_phases)):
        input_signal = intcode(phase_combination[i], input_signal)
    max_thruster_list.append(input_signal)

for signal in max_thruster_list:
    if signal > max_thruster_signal:
        max_thruster_signal = signal

print(max_thruster_signal)
