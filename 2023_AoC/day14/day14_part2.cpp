#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>
#include <algorithm>
#include <utility>

using namespace std;

pair<int, int> north (-1, 0);
pair<int, int> east (0, 1);
pair<int, int> south (1, 0);
pair<int, int> west (0, -1);

pair<int, int> findDest(pair<int, int> &pos, pair<int, int> &dir, vector<string> &field) {
  int new_row = pos.first;
  pair<int, int> next = pos;
  while (true) {
    next.first = next.first + dir.first;
    next.second = next.second + dir.second;
    
    if (next.first < 0 || next.first >= field.size() || next.second < 0 || next.second >= field[0].length()) {
      break;
    } else if (field[next.first][next.second] != '.') {
      break;
    }
  }

  pair<int, int> dest (next.first - dir.first, next.second - dir.second);
  return dest;
}

void roll(pair<int, int> &dir, vector<string> &field) {
  int r = dir.first == -1 ? 0 : field.size() - 1;
  int r_end = dir.first == -1 ? field.size() : -1;
  int r_inc = dir.first != 0 ? dir.first : 1;
  int c_inc = dir.second != 0 ? dir.second : 1;
  while (r != r_end) {
    int c = dir.second == -1 ? 0 : field[0].length() - 1;
    int c_end = dir.second == -1 ? field[0].length() : -1;
    while (c != c_end) {
      //cout << r << ", " << c << endl;
      if (field[r][c] == 'O') {
        pair<int, int> pos (r, c);
        pair<int, int> dest = findDest(pos, dir, field);
        //cout << "pos: " << r << ", " << c << ", dest: " << dest.first << ", " << dest.second << endl;
        if (dest != pos) {
          field[dest.first][dest.second] = 'O';
          field[r][c] = '.';
        }
      }
      c -= c_inc;
    }
    r -= r_inc;
  }
}

void cycle(vector<string> &field) {
  roll(north, field);
  roll(west, field);
  roll(south, field);
  roll(east, field);
}

string matrixToString(vector<string> &matrix) {
  string result;
  for (string s: matrix) {
    result += s;
  }
  return result;
}

pair<int, int> computeCycle(vector<string> &field) {
  vector<string> history;
  string begin = matrixToString(field);
  history.push_back(begin);
  
  while (true) {
    cycle(field);
    string s = matrixToString(field);
    if (find(history.begin(), history.end(), s) == history.end()) {
      history.push_back(s);
    } else {
      vector<string>::iterator it = find(history.begin(), history.end(), s);
      int start = it - history.begin();
      int cycle = history.size() - start;
      pair<int, int> result (start, cycle);
      return result;
    }
  }
}

int main() {
  string line;
  vector<string> field;

  ifstream myfile ("input.txt");
  if (myfile.is_open()) {
    while (getline (myfile, line)) {
      cout << line << endl;
      field.push_back(line);
    }
    myfile.close();
  }
  
  cout << endl;
  const auto &[cycle_start, cycle_size] = computeCycle(field);

  int remaining_cycles = (1000000000 - cycle_start) % cycle_size;
  for (int i = 0; i < remaining_cycles; i++) {
    cycle(field);
  }

  cout << endl;

  int result = 0;
  int weight = field.size();
  for (string s: field) {
    cout << s << endl;
    for (char c: s) {
      if (c == 'O') {
        result += weight;
      }
    }
    weight--;
  }
  cout << result << endl;
}
