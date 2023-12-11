#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>

using namespace std;

int getNbEmpty(int n1, int n2, vector<int> &empties) {
  int left = n1 < n2 ? n1 : n2;
  int right = n1 < n2 ? n2 : n1;
  int nb = 0;
  for (int i = left + 1; i < right; i++) {
    if (find(empties.begin(), empties.end(), i) != empties.end()) {
      nb++;
    }
  }
  return nb;
}

int main() {
  string line;
  vector<string> input;

  vector<int> emptyRows;
  vector<int> emptyColumns;

  vector<tuple<int, int>> galaxies;

  ifstream myfile ("input.txt");
  if (myfile.is_open()) {
    int i = 0;
    while (getline (myfile, line)) {
      input.push_back(line);
      // find empty rows
      if (line.find('#') == string::npos) {
        emptyRows.push_back(i);
      }
      i++;
    }
    myfile.close();
  }

  // find empty columns
  for (int i = 0; i < input[0].size(); i++) {
    bool empty = true;
    for (string row: input) {
      if (row[i] == '#') {
        empty = false;
        break;
      }
    }
    if (empty) {
      emptyColumns.push_back(i);
    }
  }

  // find the galaxies
  for (int row = 0; row < input.size(); row++) {
    for (int col = 0; col < input[row].length(); col++) {
      if (input[row][col] == '#') {
        tuple<int, int> galaxy {row, col};
        galaxies.push_back(galaxy);
      }
    }
  }

  // calculate distance between galaxies
  long result = 0;
  for (int i = 0; i < galaxies.size(); i++) {
    const auto [r0, c0] = galaxies[i];
    for (int j = i + 1; j < galaxies.size(); j++) {
      const auto [r1, c1] = galaxies[j];
      long emptyC = getNbEmpty(c0, c1, emptyColumns) * (1000000 - 1);
      long emptyR = getNbEmpty(r0, r1, emptyRows) * (1000000 - 1);
      long dist = abs(r0 - r1) + abs(c0 - c1) + emptyC + emptyR;

      result += dist;
    }
  }

  cout << result << endl;
}
