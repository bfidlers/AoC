#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>
#include <algorithm>
#include <map>
#include <tuple>

using namespace std;

int getHash(string s) {
  int result = 0;
  for (char c: s) {
    result += (int) c;
    result *= 17;
    result = result % 256;
  }
  return result;
}

vector<string> splitString(const string input, const char delimiter) {
  vector<string> elements;
  stringstream stream(input);
  string elem;

  while (getline(stream, elem, delimiter)) {
    elements.push_back(elem);
  }

  return elements;
}

int main() {
  string line;
  vector<string> input;

  ifstream myfile ("input.txt");
  if (myfile.is_open()) {
    while (getline (myfile, line)) {
      input = splitString(line, ',');
    }
    myfile.close();
  }

  map<int, vector<string>> boxes;
  vector<string> v;
  for (int i = 0; i < 256; i++) {
    boxes[i] = v;
  }
  for (string s: input) {
    if (s.find('=') != std::string::npos) {
      int hash = getHash(s.substr(0, s.length()-2));
      vector<string> &v = boxes[hash];
      bool found = false;
      for (int i = 0; i < v.size(); i++) {
        if (v[i].substr(0, v[i].length()-2) == s.substr(0, s.length()-2)) {
          v[i] = s;
          found = true;
        }
      }
      if (!found) {
        v.push_back(s);
      }
    } else {
      int hash = getHash(s.substr(0, s.length()-1));
      vector<string> &v = boxes[hash];
      bool found = false;
      for (int i = 0; i < v.size(); i++) {
        if (v[i].substr(0, v[i].length()-2) == s.substr(0, s.length()-1)) {
          erase(v, v[i]);
        }
      }
    }
  }

  int result = 0;
  for (auto const& [key, val] : boxes) {
    int i = 1;
    for (string s: val) {
      string str;
      str += s.back();
      int value = stoi(str);
      result += ((key + 1) * i * value);
      i++;
    }
  }

  cout << result << endl;
}
