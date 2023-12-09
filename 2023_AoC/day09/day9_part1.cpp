#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>

using namespace std;

vector<int> stringToNumbers(const string input, const char delimiter) {
  vector<int> elements;
  stringstream stream(input);
  string elem;

  while (getline(stream, elem, delimiter)) {
    if (elem != "") {
      elements.push_back(stoi(elem));
    }
  }

  return elements;
}

bool allZero(const vector<int> &numbers) {
  for (int nb: numbers) {
    if (nb != 0) { return false; }
  }
  return true;
}

vector<int> getDifferences(const vector<int> &numbers) {
  vector<int> diffs;

  for (int i = 1; i < numbers.size(); i++) {
    int diff = numbers[i] - numbers[i-1];
    diffs.push_back(diff);
  }
  return diffs;
}

vector<vector<int>> getHistory(const vector<int> &numbers) {
  vector<vector<int>> history;
  vector<int> current;
  current = numbers;
  history.push_back(current);

  while (!allZero(current)) {
    current = getDifferences(current);
    history.push_back(current);
  }

  return history;
}

int calculateNext(const vector<vector<int>> &history) {
  int diff = 0;
  for(int i = history.size() - 2; i >= 0; i--) {
    int last = history[i].size() - 1;
    diff += history[i][last];
  }
  return diff;
}

int main() {
  string line;
  vector<vector<int>> input;

  ifstream myfile ("input.txt");
  if (myfile.is_open()) {
    while (getline (myfile, line)) {
      if (line != "") {
        input.push_back(stringToNumbers(line, ' '));
      }
    }
    myfile.close();
  }

  int result = 0;
  for (vector<int> nbs: input) {
    vector<vector<int>> history = getHistory(nbs);
    result += calculateNext(history);
  }

  cout << result << endl;
}
