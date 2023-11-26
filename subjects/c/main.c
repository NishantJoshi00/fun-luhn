#include <stdio.h>
#include <stdlib.h>

int string_size(char *string) {
  int size = 0;
  while (*(string + size) != '\0') {
    if (string[size] < '0' || string[size] > '9') {
      printf("There are invalid characters in the input");
      exit(1);
    }
    size++;
  }
  return size;
}

void reverse(char *string, int size) {
  char tmp;
  for (int i = 0; i < size / 2; ++i) {
    tmp = string[i];
    string[i] = string[size - i - 1];
    string[size - i - 1] = tmp;
  }
}

int luhn_check(char *card_number, int size) {
  int sum = 0;
  int number;
  for (int i = 0; i < size; ++i) {
    number = card_number[i] - '0';
    sum += ((i + 1) % 2) * number;
    sum += (i % 2) * (((number * 2) / 10 + number * 2) % 10);
  }
  return sum % 10 == 0;
}

int main() {
  char card_number[25];
  int size;
  scanf(" %s", card_number);

  size = string_size(card_number);

  reverse(card_number, size);

  if (luhn_check(card_number, size))
    printf("Ok");
  else
    printf("Failed");

  return 0;
}
