import heapq

f = open("input.txt", "r")

size = 70
amount = 1024

grid = [['.' for i in range(size + 1)] for j in range(size + 1)]
start = (0, 0)
end = (size, size)

falling_bytes = []
for line in f:
  falling_bytes.append([int(nb) for nb in line.split(",")])

def draw_grid(grid):
  for line in grid:
    print(''.join(line))
  
dirs = [(0, -1), (-1, 0), (1, 0), (0, 1)]

def valid_pos(pos, grid):
  if (not 0 <= pos[0] < len(grid[0])):
    return False
  if (not 0 <= pos[1] < len(grid)):
    return False
  if grid[pos[1]][pos[0]] == '#':
    return False
  return True

def get_neighbours(node, grid): 
  neighbours = []
  for d in dirs:
    pos = (node[0] + d[0], node[1] + d[1])
    if valid_pos(pos, grid):
      neighbours.append(pos)
  return neighbours

def construct_path(prev, source, finish):
  current = finish
  path = []
  while current in prev and current != source:
    path.append(current)
    current = prev[current]
  path.append(source)
  path.reverse()
  return path

def dijkstra(graph, source, finish):
  pq = []
  prev = {}
  dist = {}
  used = set()
  
  dist[source] = 0
  heapq.heappush(pq, (0, start))

  while len(pq) != 0:
    current = heapq.heappop(pq)[1]
    if current in used:
      continue
    if current == finish:
      return construct_path(prev, source, finish)
    used.add(current)
    neighbours = get_neighbours(current, graph)
    for n in neighbours:
      alt = dist[current] + 1
      if not n in dist or alt < dist[n]:
        dist[n] = alt
        prev[n] = current
        heapq.heappush(pq, (alt, n))
  return None

for byte in falling_bytes:
  grid[byte[1]][byte[0]] = '#'
  path = dijkstra(grid, start, end)
  if path != None:
    continue
  else:
    print(str(byte[0]) + ',' + str(byte[1]))
    break
