file = open("input.txt", "r")

wires = file.read().splitlines()
first_wire = wires[0].split(",")
second_wire = wires[1].split(",")

directions = dict(L=(0, -1), R=(0, 1), U=(-1, 0), D=(1, 0))

position2 = [0, 0]
position3 = [0, 0, 0]
first_wire_positions = set()
first_wire_steps = set()
step_counter = 0
for instruction in first_wire:
    direction = instruction[0]
    number = int(instruction[1:])

    for i in range(number):
        position2[0] += directions[direction][0]
        position2[1] += directions[direction][1]
        position3[0] = position2[0]
        position3[1] = position2[1]
        position3[2] += 1
        set.add(first_wire_positions, tuple(position2))
        set.add(first_wire_steps, tuple(position3))


position2 = [0, 0]
position3 = [0, 0, 0]
second_wire_positions = set()
second_wire_steps = set()
crossings = []

for instruction in second_wire:
    direction = instruction[0]
    number = int(instruction[1:])

    for i in range(number):
        position2[0] += directions[direction][0]
        position2[1] += directions[direction][1]
        position3[0] = position2[0]
        position3[1] = position2[1]
        position3[2] += 1
        set.add(second_wire_positions, tuple(position2))
        set.add(second_wire_positions, tuple(position3))
        if tuple(position2) in first_wire_positions:
            for elem in first_wire_steps:
                if elem[0] == position2[0] and elem[1] == position2[1]:
                    sum_steps = elem[2] + position3[2]
                    crossings.append((position2[0], position2[1], sum_steps))

first_crossing = crossings[0]
fastest_crossing = (first_crossing[2])
for crossing in crossings:
    if (crossing[2]) < fastest_crossing:
        fastest_crossing = crossing[2]

print(fastest_crossing)
