#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define STB_DS_IMPLEMENTATION
#include "stb_ds.h"

struct part {
  int start;
  int end;
  int number;
};

struct symbol {
  int start;
  int end;
  char sym;
};

int main(int argc, char **argv) {
  FILE *file = fopen("../data.txt", "r");
  if (file == NULL) {
    printf("where is the fcking data\n");
    return 1;
  }

  char *line = NULL;
  size_t len = 0;

  struct part *parts;
  struct symbol *symbols;

  size_t acc = 0;

  while (getline(&line, &len, file) != -1) {
    for (int i = 0; i < (int)len; ++i) {
      char c = line[i];
      if (ispunct(c) && c != '.') {
        struct symbol a = {acc + i, acc + i, c};
        arrpush(symbols, a);
      } else if (isdigit(c)) {
        int end = i;
        for (int j = 1; j < (int)len - i; ++j) {
          if (!isdigit(line[i + j])) {
            end = i + j - 1;
            break;
          }
        }
        char *str = malloc(sizeof(char) * (end - i + 1));
        memcpy(str, &line[i], end - i + 1);

        struct part p = {acc + i, acc + end, strtol(str, NULL, 10)};
        arrpush(parts, p);
        i += end - i;
      }
    }
    acc += len;
  }

  fclose(file);

  if (line)
    free(line);

  int ls = (int)len;
  int sumA = 0;

  for (int i = 0; i < arrlen(parts); ++i) {
    struct part p = parts[i];
    for (int j = 0; j < arrlen(symbols); ++j) {
      struct symbol s = symbols[j];
      int dend = abs(s.start - p.end);
      int dstart = abs(s.start - p.start);

      if (dend == 1 || dstart == 1 || dend == ls || dstart == ls ||
          dend == ls + 1 || dstart == ls + 1 || dend == ls - 1 ||
          dstart == ls - 1) {
        sumA += p.number;
        break;
      }
    }
  }

  printf("Part A: %d\n", sumA);

  int sumB = 0;

  for (int i = 0; i < arrlen(symbols); ++i) {
    struct symbol s = symbols[i];
    if (s.sym != '*')
      continue;
    int temp = 0;

    for (int j = 0; j < arrlen(parts); ++j) {
      struct part p = parts[j];
      int dend = abs(s.start - p.end);
      int dstart = abs(s.start - p.start);

      if (dend == 1 || dstart == 1 || dend == ls || dstart == ls ||
          dend == ls + 1 || dstart == ls + 1 || dend == ls - 1 ||
          dstart == ls - 1) {
        if (temp == 0) {
          temp = p.number;
        } else if (temp > 0) {
          temp *= -p.number;
          break;
        }
      }
    }

    if (temp < 0)
      sumB -= temp;
  }

  printf("Part B: %d\n", sumB);

  arrfree(parts);
  arrfree(symbols);

  return 0;
}
