file_name = "input.txt"
max_x = 101
max_y = 103


def paint(positions):
  arr = [['.' for i in range(max_x)] for j in range(max_y)]
  for pos in positions:
    arr[pos[1]][pos[0]] = '#'
  for row in arr:
    print(''.join(row))


robots = []
f = open(file_name, "r")
for line in f:
  split1 = line.strip().split(" ")
  pos = [int(x) for x in split1[0][2:].split(",")]
  vel = [int(x) for x in split1[1][2:].split(",")]
  robots.append((pos, vel))


i = 0
min_score = 10000000000
while True:
  i += 1
  q1 = 0
  q2 = 0
  q3 = 0
  q4 = 0
  robot_positions = []
  for robot in robots:
    end_pos = ((robot[0][0] + robot[1][0] * i) % max_x, (robot[0][1] + robot[1][1] * i) % max_y)
    robot_positions.append(end_pos)

    if end_pos[0] < max_x // 2 and end_pos[1] < max_y // 2:
      q1 += 1
    elif end_pos[0] > max_x // 2 and end_pos[1] < max_y // 2:
      q2 += 1
    elif end_pos[0] > max_x // 2 and end_pos[1] > max_y // 2:
      q3 += 1
    elif end_pos[0] < max_x // 2 and end_pos[1] > max_y // 2:
      q4 += 1

  score = q1 * q2 * q3 * q4
  if score <= min_score:
    print(i, q1, q2, q3, q4)
    paint(robot_positions)
    min_score = score
  if i >= max_x * max_y:
    break
