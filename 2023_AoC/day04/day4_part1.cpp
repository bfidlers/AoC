#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>
#include <algorithm>
#include <cmath>

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

vector<int> parseNumbers(const vector<string> &nbs) {
  vector<int> parsedNbs;
  for (string s: nbs) {
    if (s.length() > 0) {
      parsedNbs.push_back(stoi(s));
    }
  }
  return parsedNbs;
}

int countScore(vector<int> &winning, const vector<int> &drawed) {
  int count = 0;
  std::vector<int>::iterator it; 
  std::vector<int> test = {30, 40, 50}; 
  for (int nb: drawed) {
    it = find(winning.begin(), winning.end(), nb);
    if (it != winning.end()) {
      count += 1;
    }
  }
  if (count == 0) {
    return 0;
  }
  return pow(2, count - 1);
}

int main() {
  string line;
  int result = 0;

  ifstream myfile ("input.txt");
  if (myfile.is_open()) {
    while (getline (myfile, line)) {
      vector<string> split = splitString(line, ':');
      vector<string> splitNumbers = splitString(split[1], '|');

      vector<string> winningNumbers = splitString(splitNumbers[0], ' ');
      vector<string> drawedNumbers = splitString(splitNumbers[1], ' ');
      
      vector<int> winningNbsParsed = parseNumbers(winningNumbers); 
      vector<int> drawedNbsParsed = parseNumbers(drawedNumbers); 

      int score = countScore(winningNbsParsed, drawedNbsParsed);
      result += score;
    }
    myfile.close();
  }
  cout << result << endl;

}
