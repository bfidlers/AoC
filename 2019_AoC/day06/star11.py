import copy


class Orbit:
    def __init__(self, name, orbits_around):
        self.name = name
        self.orbits_around = orbits_around
        self.amount_of_orbits = 0


list_of_elements = set()

file = open("input.txt", "r")
for line in file:
    line = line.strip()
    single_orbit = [str(elem) for elem in line.split(")")]
    element = Orbit(single_orbit[1], single_orbit[0])
    list_of_elements.add(element)

current_orbit = {"COM"}
next_orbit = set()
number_of_orbits = 1
for i in range(len(list_of_elements)):
    for planet2 in list_of_elements:
        if planet2.orbits_around in current_orbit:
            next_orbit.add(planet2.name)
            planet2.amount_of_orbits = number_of_orbits
    current_orbit.clear()
    current_orbit = copy.deepcopy(next_orbit)
    next_orbit.clear()
    number_of_orbits += 1

counter = 0
for planet in list_of_elements:
    counter += planet.amount_of_orbits
    print(planet.name)
    print(planet.amount_of_orbits)

print(counter)
