#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>
#include <regex>
#include <map>

using namespace std;

map<string, int> max_color = {
  {"red", 12},
  {"green", 13},
  {"blue", 14},
};

vector<string> splitString(const string input, const char delimiter) {
  vector<string> elements;
  stringstream stream(input);
  string elem;

  while (getline(stream, elem, delimiter)) {
    elements.push_back(elem);
  }

  return elements;
}

bool is_valid(const vector<string> draws) {
  for (string draw : draws) {
    vector<string> split = splitString(draw, ' ');
    if (stoi(split[1]) > max_color[split[2]]) {
      return false;
    }
  }
  return true;
}

int main() {
  string line;
  int result = 0;

  ifstream myfile ("input.txt");
  if (myfile.is_open()) {
    while (getline (myfile, line)) {
      vector<string> split = splitString(line, ':');
      int id = stoi(split[0].substr(5));

      string draws = regex_replace(split[1], regex(";"), ",");
      vector<string> split_draws = splitString(draws, ',');

      if (is_valid(split_draws)) {
        result += id;
      }
    }
    myfile.close();
  }
  cout << result << endl;

}
