import copy
from itertools import permutations

position_mode = 0
immediate_mode = 1


def int_code(data, loop_nb, first_input, second_input, i=0):
    while i < len(data):
        if data[i] == 99:
            return None, i
        else:
            instruction = data[i]
            op_code = instruction % 100

            parameter_mode1 = (instruction % 1000) // 100
            pos1 = data[i + 1]
            if parameter_mode1 == position_mode:
                parameter1 = data[pos1]
            else:
                parameter1 = pos1

            if op_code == 3:
                if loop_nb == 1:
                    data[pos1] = first_input
                    loop_nb += 1
                else:
                    data[pos1] = second_input
                i += 2
            elif op_code == 4:
                output_value = parameter1
                i += 2
                return output_value, i

            else:
                parameter_mode2 = (instruction % 10000) // 1000
                pos2 = data[i + 2]

                if parameter_mode2 == position_mode:
                    parameter2 = data[pos2]
                else:
                    parameter2 = pos2

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
                    pos3 = data[i + 3]
                    if op_code == 1:
                        data[pos3] = parameter1 + parameter2
                        i += 4
                    elif op_code == 2:
                        data[pos3] = parameter1 * parameter2
                        i += 4
                    elif op_code == 7:
                        if parameter1 < parameter2:
                            data[pos3] = 1
                        else:
                            data[pos3] = 0
                        i += 4
                    elif op_code == 8:
                        if parameter1 == parameter2:
                            data[pos3] = 1
                        else:
                            data[pos3] = 0
                        i += 4


possible_phases = [5, 6, 7, 8, 9]
possible_permutations = list(permutations(possible_phases))

f = open("input.txt", "r")
for line in f:
    list_of_values = [int(x) for x in line.split(",")]

max_thruster_list = []
max_thruster_signal = 0
for phase_combination in possible_permutations:
    input_signal = 0
    stop = False
    loop = 1
    
    data_a = copy.deepcopy(list_of_values)
    data_b = copy.deepcopy(list_of_values)
    data_c = copy.deepcopy(list_of_values)
    data_d = copy.deepcopy(list_of_values)
    data_e = copy.deepcopy(list_of_values)

    pos_a, pos_b, pos_c, pos_d, pos_e = 0, 0, 0, 0, 0

    while not stop:
        for l in range(len(possible_phases)):
            if l == 0:
                input_signal, pos_a = int_code(data_a, loop, phase_combination[l], input_signal, pos_a)
            elif l == 1:
                input_signal, pos_b = int_code(data_b, loop, phase_combination[l], input_signal, pos_b)
            elif l == 2:
                input_signal, pos_c = int_code(data_c, loop, phase_combination[l], input_signal, pos_c)
            elif l == 3:
                input_signal, pos_d = int_code(data_d, loop, phase_combination[l], input_signal, pos_d)
            elif l == 4:
                input_signal, pos_e = int_code(data_e, loop, phase_combination[l], input_signal, pos_e)
                if input_signal is not None:
                    final_signal = input_signal

            if input_signal is None:
                stop = True
                max_thruster_list.append(final_signal)

        loop += 1

for signal in max_thruster_list:
    if signal > max_thruster_signal:
        max_thruster_signal = signal

print(max_thruster_signal)
