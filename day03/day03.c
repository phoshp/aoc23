#include <ctype.h>
#include <memory.h>
#include <printf.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void vec_push(void **ptr, void *value, size_t size) {
  if (*ptr == NULL) {
    int *data = malloc(2 * (sizeof(int) + size));
    if (data == NULL) {
      printf("out of memory");
      exit(1);
    }

    data[0] = 1; // length
    data[1] = 2; // capacity
    memcpy(data + 2, value, size);
    *ptr = data + 2;
  } else {
    int *data = (int *)*ptr - 2;
    int len = data[0];
    int cap = data[1];

    if (len >= cap) {
      cap *= 2;
      data = realloc(data, cap * size + sizeof(int) * 2);
      data[1] = cap;
      *ptr = data + 2;
    }
    memcpy((char *)(data + 2) + len * size, value, size);
    data[0] = len + 1;
  }
}

int vec_len(int *ptr) {
  int *data = ptr - 2;
  return data[0];
}

void vec_free(int *ptr) { free(ptr - 2); }

#define vec_push(ptr, x) vec_push((void **)&ptr, (void *)&x, sizeof(x))
#define vec_len(x) vec_len((int *)x)
#define vec_free(x) vec_free((int *)x)

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

int main(void) {
  // assumes binary file is in the build dir
  FILE *file = fopen("../data.txt", "r");
  if (file == NULL) {
    printf("where is the fcking data\n");
    return 1;
  }

  char *line;
  size_t len = 0;

  struct part *parts;
  struct symbol *symbols;

  size_t acc = 0;

  while (getline(&line, &len, file) != -1) {
    for (int i = 0; i < (int)len; ++i) {
      char c = line[i];
      if (ispunct(c) && c != '.') {
        struct symbol a = {acc + i, acc + i, c};
        vec_push(symbols, a);
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
        vec_push(parts, p);
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

  for (int i = 0; i < vec_len(parts); ++i) {
    struct part p = parts[i];
    for (int j = 0; j < vec_len(symbols); ++j) {
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

  for (int i = 0; i < vec_len(symbols); ++i) {
    struct symbol s = symbols[i];
    if (s.sym != '*')
      continue;
    int temp = 0;

    for (int j = 0; j < vec_len(parts); ++j) {
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

  vec_free(parts);
  vec_free(symbols);

  return 0;
}
