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

def find_shortcut(path):
  shortcuts = []
  for i in range(len(path) - 1):
    for j in range(i + 1, len(path)):
      diff = (path[i][0] - path[j][0], path[i][1] - path[j][1])
      diff_length = abs(diff[0]) + abs(diff[1])
      if diff_length <= 20:
        # does contain duplicates, but does not matter because this is only for low length, which we don't care about
        shortcuts.append(j - i - diff_length)
  print(len([s for s in shortcuts if s >= 100]))

path = dijkstra(grid, start, end)
find_shortcut(path)

