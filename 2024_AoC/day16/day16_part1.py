import heapq

f = open("input.txt", "r")

start = (0, 0)
end = (0, 0)

grid = []
for line in f:
  grid.append([x for x in line.strip()])
  if 'S' in line:
    start = (line.index('S'), len(grid) - 1)
  if 'E' in line:
    end = (line.index('E'), len(grid) - 1)

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

def get_neighbours(node, ori, grid): 
  neighbours = []
  straight = (node[0] + ori[0], node[1] + ori[1])
  if valid_pos(straight, grid):
    neighbours.append((straight, ori, 1))
  l = (-1 * ori[1], ori[0])
  left = (node[0] + l[0], node[1] + l[1])
  if valid_pos(left, grid):
    neighbours.append((left, l, 1001))
  r = (ori[1], -1 * ori[0])
  right = (node[0] + r[0], node[1] + r[1])
  if valid_pos(right, grid):
    neighbours.append((right, r, 1001))
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
  d = (1, 0)
  pq = []
  prev = {}
  dist = {}
  used = set()
  
  dist[source] = 0
  heapq.heappush(pq, (0, start, d))

  while len(pq) != 0:
    head = heapq.heappop(pq)
    current_pos = head[1]
    current_dir = head[2]
    if current_pos in used:
      continue
    if current_pos == finish:
      return dist[current_pos]
      return construct_path(prev, source, finish)
    used.add(current_pos)
    neighbours = get_neighbours(current_pos, current_dir, graph)
    for (npos, ndir, cost) in neighbours:
      alt = dist[current_pos] + cost
      if not npos in dist or alt < dist[npos]:
        dist[npos] = alt
        prev[npos] = current_pos
        heapq.heappush(pq, (alt, npos, ndir))

print(dijkstra(grid, start, end))
