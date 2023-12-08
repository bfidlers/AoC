#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>
#include <map>
#include <tuple>
#include <numeric>

using namespace std;

vector<string> splitString(const string input, const char delimiter) {
  vector<string> elements;
  stringstream stream(input);
  string elem;

  while (getline(stream, elem, delimiter)) {
    if (elem != "") {
      elements.push_back(elem);
    }
  }

  return elements;
}

int findPeriod(string s, string instructions, map<string, tuple<string, string>> network) {
  int steps = 0;
  int i = 0;
  string current = s;

  while (true) {
    const auto [left, right] = network[current];
    current = instructions[i] == 'L' ? left : right;
    
    steps += 1;
    i = steps % instructions.length();

    if (current[2] == 'Z') {
      return steps;
    }
  }
}

int main() {
  string line;
  vector<string> input;
  string instructions;
  map<string, tuple<string, string>> network;
  vector<string> current;

  ifstream myfile ("input.txt");
  if (myfile.is_open()) {
    while (getline (myfile, line)) {
      if (line != "") {
        input.push_back(line);
      }
    }
    myfile.close();
  }

  instructions = input[0];

  for (int i = 1; i < input.size(); i++) {
    string id = input[i].substr(0, 3);
    if (id[2] == 'A') {
      current.push_back(id);
    }
    vector<string> split = splitString(input[i].substr(7, 8), ',');
    network[id] = {split[0], split[1].substr(1)};
  }

  vector<int> periods;
  for (string s: current) {
    int period = findPeriod(s, instructions, network);
    periods.push_back(period);
  }

  long result = 1;
  for (int nb: periods) {
    result = lcm(result, nb);
  }
  cout << result << endl;
}
