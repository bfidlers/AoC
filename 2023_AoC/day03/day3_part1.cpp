#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <regex>
#include <set>

using namespace std;

set<vector<int>> findSymbols(vector<string> &v) {
  set<vector<int>> symbols;

  for (int i = 0; i < v.size(); i++) {
    for (int j = 0; j < v[i].length(); j++) {
      if (v[i][j] == '#') {
        vector<int> pos = { (int) i, (int) j};
        symbols.insert(pos);
      }
    }
  }
  return symbols;
}

bool hasNeighbour(int row, int col, int len, set<vector<int>> &symbols) {
  for (int i = row - 1; i <= row + 1; i++) {
    for (int j = col - len; j <= col + 1; j++) {
      bool neighbouring = symbols.count({i, j});
      if (neighbouring) {
        return true;
      }
    }
  }
  return false;
}

int findNumbers(vector<string> &v, set<vector<int>> &symbols) {
  int sum = 0;
  for (int i = 0; i < v.size(); i++) {
    string number;
    for (int j = 0; j < v[i].length(); j++) {
      if (isdigit(v[i][j])) {
        number += v[i][j];
      } else if (number.length() > 0) {
        if (hasNeighbour((int) i, (int) (j - 1), number.length(), symbols)) {
          sum += stoi(number);
        }
        number = "";
      }
    }
    if (number.length() > 0) {
      if (hasNeighbour((int) i, (int) (v[i].length() -1 ), number.length(), symbols)) {
          sum += stoi(number);
      }
    }
  }
  return sum;
}

int main() {
  string line;
  vector<string> input;

  ifstream myfile ("input.txt");
  if (myfile.is_open()) {
    while (getline (myfile, line)) {
      string new_line = regex_replace(line, regex("[^0-9.]"), "#");
      input.push_back(new_line);
    }
    myfile.close();
  }

  set<vector<int>> symbols = findSymbols(input);
  int result = findNumbers(input, symbols);
  cout << result << endl;
}
