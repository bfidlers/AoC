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

current_orbit_SAN = ""
current_orbit_YOU = ""

for planet in list_of_elements:
    if planet.name == "SAN":
        current_orbit_SAN = planet.orbits_around
    elif planet.name == "YOU":
        current_orbit_YOU = planet.orbits_around

previous_orbits_SAN = {current_orbit_SAN}

while current_orbit_SAN != "COM":
    for planet in list_of_elements:
        if planet.name == current_orbit_SAN:
            current_orbit_SAN = planet.orbits_around
            previous_orbits_SAN.add(current_orbit_SAN)

previous_orbits_YOU = {current_orbit_YOU}

while current_orbit_YOU != "COM":
    for planet in list_of_elements:
        if planet.name == current_orbit_YOU:
            current_orbit_YOU = planet.orbits_around
            previous_orbits_YOU.add(current_orbit_YOU)

difference1 = previous_orbits_SAN.difference(previous_orbits_YOU)
difference2 = previous_orbits_YOU.difference(previous_orbits_SAN)
difference = difference1.union(difference2)

print(previous_orbits_SAN)
print(previous_orbits_YOU)

print(difference)
print(len(difference))