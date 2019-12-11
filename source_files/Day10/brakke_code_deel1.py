file = open("test.txt", "r")

lines = file.read().splitlines()
list_of_values = []
for line in lines:
    list_of_values.append(list(line))

biggest_value = 0
for posX1 in range(len(list_of_values)):
    for posY1 in range(len(list_of_values[0])):
        counter = 0
        if list_of_values[posX1][posY1] != ".":
            for posX2 in range(len(list_of_values)):
                for posY2 in range(len(list_of_values[0])):
                    if list_of_values[posX2][posY2] != ".":
                        diffX1 = posX1 - posX2
                        diffY1 = posY1 - posY2
                        obstruction = False
                        if abs(diffX1) > 1 and abs(diffY1) > 1:
                            for i in range(1, abs(diffX1)):
                                for j in range(1, abs(diffY1)):
                                    diffX2 = i
                                    diffY2 = j
                                    if diffY2/diffX2 == diffY1/diffX1:
                                        if diffX1 > 0:
                                            posX3 = posX1 - i
                                        else:
                                            posX3 = posX1 + i
                                        if diffY1 > 0:
                                            posY3 = posY1 - j
                                        else:
                                            posY3 = posY1 + j
                                        if list_of_values[posX3][posY3] != ".":
                                            obstruction = True
                        elif diffX1 == 0 and diffY1 == 0:
                            obstruction = True
                        elif diffX1 == 0:
                            for i in range(1, abs(diffY1)):
                                if diffY1 > 0:
                                    posY3 = posY1 - i
                                else:
                                    posY3 = posY1 + i
                                if list_of_values[posX1][posY3] != ".":
                                    obstruction = True
                        elif diffY1 == 0:
                            for j in range(1, abs(diffX1)):
                                if diffX1 > 0:
                                    posX3 = posX1 - j
                                else:
                                    posX3 = posX1 + j
                                if list_of_values[posX3][posY1] != ".":
                                    obstruction = True
                        if obstruction is False:
                            counter += 1
            list_of_values[posX1][posY1] = counter
            if counter > biggest_value:
                biggest_value = counter

print(list_of_values)
print(biggest_value)

#deel2
import math
import copy


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


file = open("test.txt", "r")
data = []
for ix, line in enumerate(file):
    data += [(ix, jx) for jx, i in enumerate(line) if i == "#"]

asteroids_to_shoot = set()
asteroids_current_cycle = set()
vaporizer = (3, 8)

for value in data:
    ast_object = Asteroid(value)
    ast_object.calculate_distance(vaporizer)
    ast_object.calculate_rotation(vaporizer)
    asteroids_to_shoot.add(ast_object)

vaporizer_real = (28, 22)
angles_current_cycle = []
ordered_objects_too_shoot = []
while len(ordered_objects_too_shoot) < 36:
    for asteroid1 in asteroids_to_shoot:
        if vaporizer != asteroid1.position and asteroid1.shot is False:
            obstruction = False
            possible_collisions = asteroids_in_between(vaporizer, asteroid1.position)
            for asteroid2 in possible_collisions:
                if asteroid2 in asteroids_to_shoot:
                    obstruction = True
            if obstruction is False:
                asteroids_current_cycle.add(asteroid1)
                angles_current_cycle.append(asteroid1.rotation)
    angles_current_cycle.sort()
    print(angles_current_cycle)
    print(len(angles_current_cycle))
    for angle in angles_current_cycle:
        print(angle)
        for asteroid in asteroids_current_cycle:
            if asteroid.rotation == angle:
                ordered_objects_too_shoot.append(asteroid)
                asteroid.shot = True
    print(len(ordered_objects_too_shoot))
    asteroids_current_cycle.clear()
    angles_current_cycle.clear()

print(ordered_objects_too_shoot)



