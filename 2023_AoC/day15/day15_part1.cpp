#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>
#include <algorithm>

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

  int result = 0;
  for (string s: input) {
    result += getHash(s);
  }
  cout << result << endl;
}
