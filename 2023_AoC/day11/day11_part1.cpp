#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>

using namespace std;

int getNbEmptyColsBetween(int c1, int c2, vector<int> &empties) {
  int left = c1 < c2 ? c1 : c2;
  int right = c1 < c2 ? c2 : c1;
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

  vector<int> emptyColumns;

  vector<tuple<int, int>> galaxies;

  ifstream myfile ("input.txt");
  if (myfile.is_open()) {
    while (getline (myfile, line)) {
      input.push_back(line);
      // if row is empty, add it twice, since it needs to be expanded
      if (line.find('#') == string::npos) {
        input.push_back(line);
      }
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
  int result = 0;
  for (int i = 0; i < galaxies.size(); i++) {
    const auto [r0, c0] = galaxies[i];
    for (int j = i + 1; j < galaxies.size(); j++) {
      const auto [r1, c1] = galaxies[j];
      int emptyRows = getNbEmptyColsBetween(c0, c1, emptyColumns);
      int dist = abs(r0 - r1) + abs(c0 - c1) + emptyRows;
      result += dist;
    }
  }

  cout << result << endl;
}
