#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>
#include <regex>
#include <map>

using namespace std;


vector<string> splitString(const string input, const char delimiter) {
  vector<string> elements;
  stringstream stream(input);
  string elem;

  while (getline(stream, elem, delimiter)) {
    elements.push_back(elem);
  }

  return elements;
}

int getPower(const vector<string> draws) {
  map<string, int> max_color = {
    {"red", 0},
    {"green", 0},
    {"blue", 0},
  };
  for (string draw : draws) {
    vector<string> split = splitString(draw, ' ');
    if (stoi(split[1]) > max_color[split[2]]) {
      max_color[split[2]] = stoi(split[1]); 
    }
  }
  return max_color["red"] * max_color["green"] * max_color["blue"];
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

      result += getPower(split_draws);
    }
    myfile.close();
  }
  cout << result << endl;

}
