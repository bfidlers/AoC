import math


def asteroids_in_between(ast1, ast2):
    asteroids = set()
    diff = [ast2[0] - ast1[0], ast2[1] - ast1[1]]
    gcd = math.gcd(diff[0], diff[1])
    increment = [diff[0]//gcd, diff[1]//gcd]
    pos3 = asteroid1
    while pos3 != list(asteroid2):
        pos3 = [pos3[0] + increment[0], pos3[1] + increment[1]]
        if pos3 != list(asteroid2):
            asteroids.add(tuple(pos3))
    return asteroids


file = open("input.txt", "r")
data = []
for ix, line in enumerate(file):
    data += [(ix, jx) for jx, i in enumerate(line) if i == "#"]

biggest_value = 0
for asteroid1 in data:
    counter = 0
    for asteroid2 in data:
        if asteroid1 != asteroid2:
            obstruction = False
            possible_collisions = asteroids_in_between(asteroid1, asteroid2)
            for asteroid3 in possible_collisions:
                if asteroid3 in data:
                    obstruction = True
            if obstruction is False:
                counter += 1
    if counter >= biggest_value:
        biggest_value = counter
        best_position = list(asteroid1)

print(biggest_value)
print(best_position)
