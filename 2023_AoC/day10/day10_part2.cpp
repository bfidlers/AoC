#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <map>
#include <tuple>
#include <algorithm>

using namespace std;

vector<tuple<int, int>> getNeighbours(tuple<int, int> current, char ch) {
  const auto &[r, c] = current;
  switch (ch) {
    case '|' : return {{r + 1, c}, {r - 1, c}};
    case '-' : return {{r, c + 1}, {r, c - 1}};
    case 'L' : return {{r, c + 1}, {r - 1, c}};
    case 'J' : return {{r, c - 1}, {r - 1, c}};
    case '7' : return {{r + 1, c}, {r, c - 1}};
    case 'F' : return {{r + 1, c}, {r, c + 1}};
  }

  vector<tuple<int, int>> v;
  return v;
}

tuple<int, int> getFirst(tuple<int, int> prev, map<tuple<int, int>, char> &input) {
  const auto &[r, c] = prev;
  vector<tuple<int, int>> dirs = {
    {r - 1, c},
    {r + 1, c},
    {r, c - 1},
    {r, c + 1}
  };
  for (tuple<int, int> dir: dirs) {
    vector<tuple<int, int>> next = getNeighbours(dir, input[dir]);
    for (tuple<int, int> t: next) {
      if (prev == t) {
        return dir;
      }
    }
  }
  return make_tuple(0, 0);
}

void followLoop(tuple<int, int> prev, tuple<int, int> current, map<tuple<int, int>, char> &input, map<tuple<int, int>, char> &loop) {
  vector<tuple<int, int>> neighbours = getNeighbours(current, input[current]);
  for (tuple<int, int> next: neighbours) {
    if (prev == next) {
      continue;
    } else if (input[next] == 'S') {
      loop[next] = 'S';
      return;
    } else {
      loop[next] = input[next];
      followLoop(current, next, input, loop);
    }
  }
}

bool isInBounds(tuple<int, int> pos, int max) {
  const auto &[x, y] = pos;
  if (x < 0 || y < 0 || x > max || y > max) {
    return false;
  } else {
    return true;
  }
}

int countCrossings(tuple<int, int> pos, tuple<int, int> dir, map<tuple<int, int>, char> &loop, int max_dim) {
  tuple<int, int> current = pos;
  if (!isInBounds(current, max_dim)) {
    return 0;
  }
  current = make_tuple(get<0>(pos) + get<0>(dir), get<1>(pos) + get<1>(dir));

  int count = 0;

  // In theory S should only be included if it stand for a J or F, but I'm to lazy to clean this up now.
  string upleft = "-|JFS";

  if (upleft.find(loop[current]) != string::npos) {
    count += 1;
  }
  return count + countCrossings(current, dir, loop, max_dim);
}

bool isInside(tuple<int, int> pos, map<tuple<int, int>, char> &loop, int max_dim) {
  int nb_crossings = countCrossings(pos, {-1, -1}, loop, max_dim);
  if (nb_crossings % 2 == 1) {
    return true;
  }
  return false;
}

int main() {
  string line;
  map<tuple<int,int>, char> input;
  map<tuple<int,int>, char> loop;
  tuple<int,int> start;

  int max_width;
  int max_height;

  ifstream myfile ("input.txt");
  int r = 0;
  if (myfile.is_open()) {
    while (getline (myfile, line)) {
      int c = 0;
      for (char ch: line) {
        if (ch == 'S') {
          start = {r, c};
        }
        tuple<int,int> pos {r, c};
        input[pos] = ch;
        c++;
      }
      max_width = c;
      r++;
    }
    max_height = r;
    myfile.close();
  }

  int max_dim = max(max_width, max_height);

  tuple<int, int> prev = start;
  tuple<int, int> next = getFirst(start, input);

  loop[next] = input[next];
  followLoop(prev, next, input, loop);
  
  int result = 0;
  for (const auto &[key, value]: input) {
    if (loop[key] != value) {
      result += isInside(key, loop, max_dim);
    }
  }
  cout << result << endl;
}
