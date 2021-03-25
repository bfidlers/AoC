import math
import copy
import time


class Asteroid:
    def __init__(self, position):
        self.position = position
        self.distance = 0
        self.rotation = 0
        self.shot = False

    def calculate_distance(self, origin):
        self.distance = math.sqrt((self.position[0] - origin[0]) ** 2 + (self.position[1] - origin[1]) ** 2)

    def calculate_rotation(self, origin):
        diff = (self.position[0] - origin[0], self.position[1] - origin[1])
        if diff[0] >= 0 and diff[1] > 0:
            self.rotation = math.sin(abs(diff[0])/self.distance) + math.pi/2
        if diff[0] > 0 and diff[1] <= 0:
            self.rotation = math.sin(abs(diff[1])/self.distance) + math.pi
        if diff[0] <= 0 and diff[1] < 0:
            self.rotation = math.sin(abs(diff[0])/self.distance) + 3 * math.pi/2
        if diff[0] < 0 and diff[1] >= 0:
            self.rotation = math.sin(abs(diff[1])/self.distance)


def asteroids_in_between(ast1, ast2):
    asteroids = set()
    diff = [ast2[0] - ast1[0], ast2[1] - ast1[1]]
    gcd = math.gcd(diff[0], diff[1])
    increment = [diff[0]//gcd, diff[1]//gcd]
    pos3 = ast1
    while pos3 != list(ast2):
        pos3 = [pos3[0] + increment[0], pos3[1] + increment[1]]
        if pos3 != list(ast2):
            asteroids.add(tuple(pos3))
    return asteroids


def add_object_too_shoot(ast1):
    ast1.calculate_distance(vaporizer)
    ast1.calculate_rotation(vaporizer)
    asteroids_current_cycle.add(ast1)
    angles_current_cycle.append(ast1.rotation)


file = open("input.txt", "r")
data = []
for ix, line in enumerate(file):
    data += [(ix, jx) for jx, i in enumerate(line) if i == "#"]

asteroids_to_shoot = set(copy.deepcopy(data))
asteroids_current_cycle = set()

vaporizer = (28, 22)
asteroids_to_shoot.remove(vaporizer)
angles_current_cycle = []
ordered_objects_too_shoot = []
while len(ordered_objects_too_shoot) < 200:
    for asteroid1 in asteroids_to_shoot:
        if vaporizer != asteroid1:
            obstruction = False
            ast_object = Asteroid(asteroid1)
            possible_collisions = asteroids_in_between(vaporizer, asteroid1)
            for asteroid2 in possible_collisions:
                if asteroid2 in asteroids_to_shoot:
                    obstruction = True
            if obstruction is False:
                add_object_too_shoot(ast_object)
    angles_current_cycle.sort()
    print(angles_current_cycle)
    for angle in angles_current_cycle:
        for asteroid in asteroids_current_cycle:
            if asteroid.rotation == angle:
                ordered_objects_too_shoot.append(asteroid)
                if asteroid.position in asteroids_to_shoot:
                    asteroids_to_shoot.remove(asteroid.position)
    asteroids_current_cycle.clear()
    angles_current_cycle.clear()
    time.sleep(1)

for i, element in enumerate(ordered_objects_too_shoot):
    print(i, element.position)




