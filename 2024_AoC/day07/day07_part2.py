file = open("input.txt", "r")


def consume(nb_list):
  l = len(nb_list)
  if l == 1:
    return [nb_list[0]]
  rest = consume(nb_list[:l-1])
  return [x + nb_list[l-1] for x in rest] + [x * nb_list[l-1] for x in rest] + [int(str(x)+str(nb_list[l-1])) for x in rest]


result = 0
for x in file:
  [total_string, nb_string] = x.strip().split(": ")
  nbs = [int(nb) for nb in nb_string.split(" ")]
  total = int(total_string)
  possibilities = consume(nbs)
  if total in possibilities:
    result += total

print(result)
