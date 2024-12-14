file_name = "input.txt"
max_x = 101
max_y = 103
time = 100

robots = []
q1 = 0
q2 = 0
q3 = 0
q4 = 0
f = open(file_name, "r")
for line in f:
  split1 = line.strip().split(" ")
  pos = [int(x) for x in split1[0][2:].split(",")]
  vel = [int(x) for x in split1[1][2:].split(",")]
  end_pos = ((pos[0] + vel[0] * 100) % max_x, (pos[1] + vel[1] * 100) % max_y)

  if end_pos[0] < max_x // 2 and end_pos[1] < max_y // 2:
    q1 += 1
  elif end_pos[0] > max_x // 2 and end_pos[1] < max_y // 2:
    q2 += 1
  elif end_pos[0] > max_x // 2 and end_pos[1] > max_y // 2:
    q3 += 1
  elif end_pos[0] < max_x // 2 and end_pos[1] > max_y // 2:
    q4 += 1

score = q1 * q2 * q3 * q4
print(score)
