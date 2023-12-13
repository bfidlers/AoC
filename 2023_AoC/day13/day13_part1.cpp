#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>
#include <algorithm>

using namespace std;

bool checkHorizontalReflection(vector<string> &pattern, int start) {
  int end = pattern.size() - (start + 1);
  int diff = min(start + 1, end);
  for (int i = 1; i < diff; i++) {
    if (pattern[start - i] != pattern[start + 1 + i]) {
      return false;
    }
  }
  return true;
}

int findHorizontalReflection(vector<string> &pattern) {
  for (int i = 0; i < pattern.size() - 1; i++) {
    if (pattern[i] == pattern[i + 1]) {
      if (checkHorizontalReflection(pattern, i)) {
        return i + 1;
      }
    }
  }
  return 0;
}

bool checkColumn(vector<string> &pattern, int c1, int c2) {
  for (int r = 0; r < pattern.size(); r++) {
    if (pattern[r][c1] != pattern[r][c2]) {
      return false;
    }
  }
  return true;
}

bool checkVerticalReflection(vector<string> &pattern, int start) {
  int end = pattern[0].length() - (start + 1);
  int diff = min(start + 1, end);
  for (int i = 1; i < diff; i++) {
    if (!checkColumn(pattern, start - i, start + 1 + i)) {
      return false;
    }
  }
  return true;
}

int findVerticalReflection(vector<string> &pattern) {
  for (int c = 0; c < pattern[0].length() - 1; c++) {
    if (checkColumn(pattern, c, c+1)) {
      if (checkVerticalReflection(pattern, c)) {
        return c + 1;
      }
    }
  }
  return 0;
}

int main() {
  string line;
  vector<vector<string>> notes;

  ifstream myfile ("input.txt");
  if (myfile.is_open()) {
    vector<string> pattern;
    while (getline (myfile, line)) {
      if (line == "") {
        notes.push_back(pattern);
        pattern.clear();
      } else {
        pattern.push_back(line);
      }
    }
    notes.push_back(pattern);
    myfile.close();
  }

  int result = 0;
  for (vector<string> block: notes) {
    result += findHorizontalReflection(block) * 100;
    result += findVerticalReflection(block);
  }
  cout << result << endl;
}
