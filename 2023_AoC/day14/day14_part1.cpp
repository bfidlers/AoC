#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>
#include <algorithm>

using namespace std;

int findDest(int row, int col, vector<string> &field) {
  int dest = row;
  for (int i = row - 1; i >= 0; i--) {
    if (field[i][col] == '.') {
      dest = i;
    } else {
      return dest;
    }
  }
  return dest;
}

void rollUp(vector<string> &field) {
  for (int r = 0; r < field.size(); r++) {
    for (int c = 0; c < field[r].length(); c++) {
      if (field[r][c] == 'O') {
        int dest = findDest(r, c, field);
        if (dest != r) {
          field[dest][c] = 'O';
          field[r][c] = '.';
        }
      }
    }
  }
}

int main() {
  string line;
  vector<string> field;

  ifstream myfile ("input.txt");
  if (myfile.is_open()) {
    while (getline (myfile, line)) {
      field.push_back(line);
    }
    myfile.close();
  }
  rollUp(field);

  int result = 0;
  int weight = field.size();
  for (string s: field) {
    for (char c: s) {
      if (c == 'O') {
        result += weight;
      }
    }
    weight--;
  }
  cout << result << endl;
}
