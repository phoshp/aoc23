#include <cmath>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

struct Card {
  int no;
  int matching_count;
  int copy = 0;
};

int main(void) {
  std::ifstream file("../data.txt");
  std::vector<Card> cards;

  std::string line;
  while (std::getline(file, line)) {
    std::stringstream ss(line);
    std::string word;
    ss >> word;
    ss >> word;
    int no = std::atoi(word.erase(word.size() - 1, 1).c_str());
    std::vector<int> left;
    std::vector<int> right;

    bool is_left = true;
    while (ss >> word) {
      if (word == "|") {
        ss >> word;
        is_left = false;
      }
      if (is_left) {
        left.push_back(std::atoi(word.c_str()));
      } else {
        right.push_back(std::atoi(word.c_str()));
      }
    }

    int n = 0;
    for (int a : left) {
      for (int b : right) {
        if (a == b) {
          n++;
          break;
        }
      }
    }

    cards.push_back(Card{no, n});
  }

  int sumA = 0;
  for (Card &card : cards) {
    if (card.matching_count > 0)
      sumA += std::pow(2, card.matching_count - 1);
  }
  std::cout << "Part A: " << sumA << std::endl;

  for (Card &card : cards) {
    if (card.matching_count > 0) {
      for (Card &c : cards) {
        if (c.no > card.no && c.no <= card.no + card.matching_count) {
          c.copy += card.copy + 1;
        }
      }
    }
  }

  int total = cards.size();
  for (Card &card : cards) {
    total += card.copy;
  }
  std::cout << "Part B: " << total << std::endl;

  return 0;
}
