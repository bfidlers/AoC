file = open("input.txt", "r")

wires = file.read().splitlines()
first_wire = wires[0].split(",")
second_wire = wires[1].split(",")

directions = dict(L=(0, -1), R=(0, 1), U=(-1, 0), D=(1, 0))

position = [0, 0]
first_wire_positions = set()
for instruction in first_wire:
    direction = instruction[0]
    number = int(instruction[1:])

    for i in range(number):
        position[0] += directions[direction][0]
        position[1] += directions[direction][1]
        set.add(first_wire_positions, tuple(position))

position = [0, 0]
second_wire_positions = set()
crossings = []
for instruction in second_wire:
    direction = instruction[0]
    number = int(instruction[1:])

    for i in range(number):
        position[0] += directions[direction][0]
        position[1] += directions[direction][1]
        set.add(second_wire_positions, tuple(position))
        if tuple(position) in first_wire_positions:
            crossings.append(tuple(position))

first_crossing = crossings[0]
closest_crossing = (abs(first_crossing[0]) + abs(first_crossing[1]))
for crossing in crossings:
    if (abs(crossing[0]) + abs(crossing[1])) < closest_crossing:
        closest_crossing = (abs(crossing[0]) + abs(crossing[1]))

print(closest_crossing)
