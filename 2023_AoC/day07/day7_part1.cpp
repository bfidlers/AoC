#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>
#include <map>
#include <algorithm>

using namespace std;

map<char, int> cardValue = {
  {'2', 1},
  {'3', 2},
  {'4', 3},
  {'5', 4},
  {'6', 5},
  {'7', 6},
  {'8', 7},
  {'9', 8},
  {'T', 9},
  {'J', 10},
  {'Q', 11},
  {'K', 12},
  {'A', 13},
  };

struct Game {
  string hand;
  long bid;
  int rank;

  Game (string s) {
    hand = s.substr(0,5);
    bid = stol(s.substr(6,-1));
    rank = calculateRank();
  }

  int calculateRank() {
    map<char, int> charMap;
    for (char c: hand) {
      charMap[c] = charMap.count(c) ? charMap[c] + 1 : 1;
    }
    
    int max = 1;
    int snd = 1;
    for (auto const& [key, val] : charMap) {
      if (val >= max) {
        snd = max;
        max = val;
      } else if (val >= snd) {
        snd = val;
      }
    }

    if (max <= 2) {
      return snd == 1 ? max : 3;
    } else if (max == 3) {
      return max + snd;
    } else {
      return max + 2;
    }
  }
};

bool compareGames(const Game &a, const Game &b) {
  if (a.rank != b.rank) {
    return a.rank < b.rank;
  }
  for (int i = 0; i < a.hand.length(); i++) {
    if (cardValue[a.hand[i]] != cardValue[b.hand[i]]) {
      return cardValue[a.hand[i]] < cardValue[b.hand[i]];
    }
  }
  return false;
}

int main() {
  string line;
  vector<Game> games;

  ifstream myfile ("input.txt");
  if (myfile.is_open()) {
    while (getline (myfile, line)) {
      Game game (line);
      games.push_back(game);
    }
    myfile.close();
  }

  long result = 0;
  stable_sort(games.begin(), games.end(), compareGames);
  for (int i = 0; i < games.size(); i++) {
    long score = games[i].bid * (i + 1);
    result += score;
  }

  cout << result << endl;
}
