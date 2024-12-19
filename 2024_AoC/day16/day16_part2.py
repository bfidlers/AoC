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

def go_back(grid, pos, prev, dist, paths):
  if pos not in prev:
    return paths
  previous = prev[pos]
  new_paths = []
  for p in previous:
    tmp_paths = [[p] + path for path in paths if p not in path]
    if len(tmp_paths) == 0:
      continue
    result = go_back(grid, p, prev, dist, tmp_paths)
    new_paths.extend(result)
  return new_paths

def construct_all(grid, prev, dist, finish):
  paths = [[finish]]
  return go_back(grid, finish, prev, dist, paths)

def dijkstra(graph, source, finish):
  d = (1, 0)
  pq = []
  prev = {}
  dist = {}
  
  dist[source] = 0
  heapq.heappush(pq, (0, start, d))
  minimum_score = 0

  while len(pq) != 0:
    head = heapq.heappop(pq)
    current_pos = head[1]
    current_dir = head[2]
    if current_pos == finish and minimum_score == 0:
      minimum_score = dist[current_pos]
    if current_pos == finish and dist[current_pos] > minimum_score:
      break
    neighbours = get_neighbours(current_pos, current_dir, graph)
    for (npos, ndir, cost) in neighbours:
      alt = dist[current_pos] + cost
      if not npos in dist:
        dist[npos] = alt
        prev[npos] = {current_pos}
        heapq.heappush(pq, (alt, npos, ndir))
      elif alt <= dist[npos]:
        dist[npos] = alt
        prev[npos].add(current_pos)
        heapq.heappush(pq, (alt, npos, ndir))
      else:
        prev[npos].add(current_pos)
  return minimum_score, prev, dist

def calculate_score(path, d):
  if len(path) <= 1:
    return 0
  diff = (path[1][0] - path[0][0], path[1][1] - path[0][1])
  if diff == d:
    return 1 + calculate_score(path[1:], d)
  return 1001 + calculate_score(path[1:], diff)

def substitute(grid, positions, s):
  for pos in positions:
    grid[pos[1]][pos[0]] = s

minimum_score, prev, dist = dijkstra(grid, start, end)
all_paths = construct_all(grid, prev, dist, end)
spots = set()
for path in all_paths:
  score = calculate_score(path, (1, 0))
  if score == minimum_score:
    spots.update(path)

substitute(grid, spots, 'O')
draw_grid(grid)
print(len(spots))
