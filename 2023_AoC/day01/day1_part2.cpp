#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <map>

using namespace std;

map<string, string> m = {
  {"one", "1"},
  {"two", "2"},
  {"three", "3"},
  {"four", "4"},
  {"five", "5"},
  {"six", "6"},
  {"seven", "7"},
  {"eight", "8"},
  {"nine", "9"},
};

int extractNumbers(string str) {
  vector<char> numbers;
  for (int i = 0; i < str.length(); i++) {
    if (isdigit(str[i])) {
      numbers.push_back(str[i]);
    }
  }
  string result = string() + numbers[0] + numbers[numbers.size() - 1];
  return stoi(result);
}

bool subString(string &s1, const string &s2) {
  if (s1.length() > s2.length()) {
    return false;
  }
  for (int i = 0; i < s1.length(); i++) {
    if (s1[i] != s2[i]) {
      return false;
    }
  }
  return true;
}

bool checkSubStrings(string &s1) {
  for (const auto &myPair : m) {
    if (subString(s1, myPair.first)) {
      return true;
    }
  }
  return false;
}

void replaceNumbers(string &str) {
  string output;
  for (int i = 0; i < str.length(); i++) {
    if (i + 1 == str.length()) {
      output += str[i];
      break;
    }
    string substring = string() + str[i];
    for (int j = 1; j <= str.length() - i; j++) {
      if (m.count(substring) > 0) {
        output += m[substring];
        break;
      }
      if (!checkSubStrings(substring)) {
        output += str[i];
        break;
      }
      substring += str[i+j];
    }
  }
  str = output;
}

int main() {
  string line;
  int sum;

  ifstream myfile ("input.txt");
  if (myfile.is_open()) {
    while ( getline (myfile, line)) {
      replaceNumbers(line);
      int n = extractNumbers(line);
      sum += n;
    }
    myfile.close();
  } else cout << "Unable to open file";

  cout << sum;
}
