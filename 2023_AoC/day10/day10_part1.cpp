#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <map>
#include <tuple>

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

int getNext(tuple<int, int> prev, tuple<int, int> current, map<tuple<int, int>, char> &input) {
  vector<tuple<int, int>> neighbours = getNeighbours(current, input[current]);
  for (tuple<int, int> next: neighbours) {
    if (prev == next) {
      continue;
    } else if (input[next] == 'S') {
      return 1;
    } else {
      return 1 + getNext(current, next, input);
    }
  }
  return -1;
}

int main() {
  string line;
  map<tuple<int,int>, char> input;
  tuple<int,int> start;

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
      r++;
    }
    myfile.close();
  }

  tuple<int, int> prev = start;
  tuple<int, int> next = getFirst(start, input);

  int total_length = 1 + getNext(prev, next, input);
  int result = total_length / 2;

  cout << result << endl;
}
