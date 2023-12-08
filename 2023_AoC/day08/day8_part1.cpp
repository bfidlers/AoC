#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>
#include <map>
#include <tuple>

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

int main() {
  string line;
  vector<string> input;
  string instructions;
  map<string, tuple<string, string>> network;
  string start = "AAA";
  string end = "ZZZ";
  string current = start;

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
    vector<string> split = splitString(input[i].substr(7, 8), ',');
    network[id] = {split[0], split[1].substr(1)};
  }

  int i = 0;
  int steps = 0;
  while (current != end) {
    const auto [left, right] = network[current];
    current = instructions[i] == 'L' ? left : right;

    steps += 1;
    i = steps % instructions.length();
  }

  cout << steps << endl;

}
