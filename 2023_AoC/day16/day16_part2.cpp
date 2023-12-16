#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>
#include <set>
#include <utility>
#include <tuple>

using namespace std;

void walk(pair<int, int> start, pair<int, int> dir, vector<string> &input, set<tuple<int, int, int, int>> &positions) {
  tuple<int, int, int, int> zever(start.first, start.second, dir.first, dir.second);
  if (positions.contains(zever)) {
    return;
  }
  positions.insert(zever);
  pair<int, int> next = make_pair(start.first + dir.first, start.second + dir.second);
  if (next.first < 0 || next.first >= input.size() || next.second < 0 || next.second >= input[0].length()) {
    return;
  }

  char c = input[next.first][next.second];
  if (c == '.') {
    walk(next, dir, input, positions);
  } else if (c == '\\') {
    pair<int, int> new_dir = make_pair(dir.second, dir.first);
    walk(next, new_dir, input, positions);
  } else if (c == '/') {
    pair<int, int> new_dir = make_pair(dir.second * (-1), dir.first * (-1));
    walk(next, new_dir, input, positions);
  } else if (c == '|') {
    if (dir.first != 0) {
      walk(next, dir, input, positions);
    } else {
      pair<int, int> new_dir1 (-1, 0);
      walk(next, new_dir1, input, positions);
      pair<int, int> new_dir2 (1, 0);
      walk(next, new_dir2, input, positions);
    }
  } else if (c == '-') {
    if (dir.second != 0) {
      walk(next, dir, input, positions);
    } else {
      pair<int, int> new_dir1 (0, -1);
      walk(next, new_dir1, input, positions);
      pair<int, int> new_dir2 (0, 1);
      walk(next, new_dir2, input, positions);
    }
  }
}

int getNbTiles(pair<int, int> start, pair<int, int> dir, vector<string> &input) {
  set<tuple<int, int, int, int>> positions;
  walk(start, dir, input, positions);

  set<pair<int, int>> actual_positions;
  for (tuple<int, int, int, int> pos: positions) {
    pair<int, int> actual_pos(get<0>(pos), get<1>(pos));
    actual_positions.insert(actual_pos);
  }
  return actual_positions.size() - 1;
}

int main() {
  string line;
  vector<string> input;

  ifstream myfile ("input.txt");
  if (myfile.is_open()) {
    while (getline (myfile, line)) {
      input.push_back(line);
    }
    myfile.close();
  }

  int max = 0;
  // From left;
  pair<int, int> dir(0, 1);
  for (int i = 0; i < input.size(); i++) {
    pair<int, int> start(i, -1);
    int nb = getNbTiles(start, dir, input);
    if (nb > max) max = nb;
  }
  // From right;
  dir = make_tuple(0, -1);
  for (int i = 0; i < input.size(); i++) {
    pair<int, int> start(i, input[0].length());
    int nb = getNbTiles(start, dir, input);
    if (nb > max) max = nb;
  }
  // From up;
  dir = make_tuple(1, 0);
  for (int i = 0; i < input[0].length(); i++) {
    pair<int, int> start(-1, i);
    int nb = getNbTiles(start, dir, input);
    if (nb > max) max = nb;
  }
  // From down;
  dir = make_tuple(-1, 0);
  for (int i = 0; i < input[0].length(); i++) {
    pair<int, int> start(input.size(), i);
    int nb = getNbTiles(start, dir, input);
    if (nb > max) max = nb;
  }
  cout << max << endl;
}
