f = open("input.txt", "r")

def next_secret_number(nb):
  n1 = ((nb * 64) ^ nb) % 16777216
  n2 = ((n1 // 32) ^ n1) % 16777216
  n3 = ((n2 * 2048) ^ n2) % 16777216
  return n3

def get_prices(nb):
  prices = [nb % 10]
  for i in range(2000):
    nb = next_secret_number(nb)
    prices.append(nb % 10)
  return prices

total_bananas = {}
for l in f:
  prices = get_prices(int(l))
  seen = set()
  for i in range(len(prices) - 4):
    subseq = tuple([prices[i + k + 1] - prices[i + k] for k in range(4)])
    if subseq not in seen:
      seen.add(subseq)
      total_bananas[subseq] = total_bananas.get(subseq, 0) + prices[i + 4]

print(max(total_bananas.values()))
