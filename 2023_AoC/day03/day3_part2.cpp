#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <regex>
#include <set>
#include <map>

using namespace std;

set<vector<int>> findSymbols(vector<string> &v) {
  set<vector<int>> symbols;

  for (int i = 0; i < v.size(); i++) {
    for (int j = 0; j < v[i].length(); j++) {
      if (v[i][j] == '*') {
        vector<int> pos = { (int) i, (int) j};
        symbols.insert(pos);
      }
    }
  }
  return symbols;
}

bool hasNeighbour(int row, int col, int len, set<vector<int>> &symbols, string &s) {
  for (int i = row - 1; i <= row + 1; i++) {
    for (int j = col - len; j <= col + 1; j++) {
      bool neighbouring = symbols.count({i, j});
      if (neighbouring) {
        s = "r:" + to_string(i) + ",c:" + to_string(j);
        return true;
      }
    }
  }
  return false;
}

int findNumbers(vector<string> &v, set<vector<int>> &symbols) {
  map<string, vector<int>> m;
  int sum = 0;
  for (int i = 0; i < v.size(); i++) {
    string number;
    for (int j = 0; j < v[i].length(); j++) {
      if (isdigit(v[i][j])) {
        number += v[i][j];
      } else if (number.length() > 0) {
        string str;
        if (hasNeighbour((int) i, (int) (j - 1), number.length(), symbols, str)) {
          vector<int> nbs;
          if (m.count(str)) {
            nbs = m[str];
          }
          nbs.push_back(stoi(number));
          m[str] = nbs;
        }
        number = "";
      }
    }
    if (number.length() > 0) {
      string str;
      if (hasNeighbour((int) i, v[i].length() - 1, number.length(), symbols, str)) {
        vector<int> nbs;
        if (m.count(str)) {
          nbs = m[str];
        }
        nbs.push_back(stoi(number));
        m[str] = nbs;
      }
    }
  }

  for (const auto &[key, value] : m) {
    if (value.size() == 2) {
      sum += (value[0] * value[1]);
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
      input.push_back(line);
    }
    myfile.close();
  }

  set<vector<int>> symbols = findSymbols(input);
  int result = findNumbers(input, symbols);
  cout << result << endl;
}
