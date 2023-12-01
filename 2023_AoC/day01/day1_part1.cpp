#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>

using namespace std;

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

int main() {
  string line;
  int sum;
  
  ifstream myfile ("input.txt");
  if (myfile.is_open()) {
    while ( getline (myfile, line)) {
      int n = extractNumbers(line);
      sum += n;
    }
    myfile.close();
  } else cout << "Unable to open file";

  cout << sum << endl;
}
