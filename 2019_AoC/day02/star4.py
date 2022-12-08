f = open("input.txt", "r")
for line in f:
    original_list = [int(x) for x in line.split(",")]

for noun in range(100):
    for verb in range(100):

        adapted_list = original_list.copy()

        adapted_list[1] = noun
        adapted_list[2] = verb

        i = 0
        while i < len(adapted_list):
            if adapted_list[i] == 99:
                break
            else:
                pos1 = adapted_list[i + 1]
                pos2 = adapted_list[i + 2]
                pos3 = adapted_list[i + 3]

                if adapted_list[i] == 1:
                    adapted_list[pos3] = adapted_list[pos1] + adapted_list[pos2]
                elif adapted_list[i] == 2:
                    adapted_list[pos3] = adapted_list[pos1] * adapted_list[pos2]
            i += 4

        if adapted_list[0] == 19690720:
            print(noun)
            print(verb)
