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

int findHorizontalReflection(vector<string> &pattern, int old = 0) {
  for (int i = 0; i < pattern.size() - 1; i++) {
    if (pattern[i] == pattern[i + 1]) {
      if (checkHorizontalReflection(pattern, i)) {
        if (i + 1 != old) {
          return i + 1;
        }
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

int findVerticalReflection(vector<string> &pattern, int old = 0) {
  for (int c = 0; c < pattern[0].length() - 1; c++) {
    if (checkColumn(pattern, c, c+1)) {
      if (checkVerticalReflection(pattern, c)) {
        if (c + 1 != old) {
          return c + 1;
        }
      }
    }
  }
  return 0;
}

int changeOne(vector<string> &pattern) {
  int original_row = findHorizontalReflection(pattern);
  int original_col = findVerticalReflection(pattern);
  for (int i = 0; i < pattern.size() * pattern[0].length(); i ++) {
    int r = i / pattern[0].length();
    int c = i % pattern[0].length();

    pattern[r][c] = pattern[r][c] == '.' ? '#' : '.'; 
    
    int new_row = findHorizontalReflection(pattern, original_row) * 100;
    int new_col = findVerticalReflection(pattern, original_col);
    
    pattern[r][c] = pattern[r][c] == '.' ? '#' : '.'; 

    if (new_row != 0 || new_col != 0) {
      int result = new_row + new_col;
      return result;
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
  for (vector<string> &block: notes) {
    result += changeOne(block);
  }
  cout << result << endl;
}
