#define _CRT_SECURE_NO_WARNINGS
#include <stdlib.h>
#include <stdio.h>
#include <time.h>

extern char* guess();
extern void figure_out(char* ptr);

int main() {
	srand(time(NULL));
	int menu;
	printf("----- MAIN MENU -----\n");
	printf("1) Try to find out this number\n");
	printf("2) Ok, computer will try\n");
	printf("3) Rules\n");
	printf("4) You can't exit from here\n");
	printf("Enter your option : ");
	scanf("%d", &menu);

	if (menu == 1) {
		printf("Ok, prepare yourself\n");
		char* ptr = malloc(sizeof(char) * 4);
		ptr[0] = rand() % 10 + '0';
		ptr[1] = rand() % 10 + 48;
		ptr[2] = rand() % 10 + 48;
		ptr[3] = rand() % 10 + 48;
		figure_out(ptr);
		printf("Ok.\n");
	}
	else if (menu == 2) {
		printf("Ok...\n");
		char* ptr = guess();
		printf("%s is your number, and you are noob...\n", ptr);
		printf("It was too easy...\n");
	}
	else if (menu == 3) {
		printf("Rules are simple. You (or I) will try to guess opponents number.\n");
		printf("The other side (I (or you)) will answer like this : \n");
		printf("N M, where N - bulls count and M - cows count\n");
		printf("If N is equal to 4 - I won (or u)\n");
	}
	else if (menu == 4) {
		exit(0);
	}

	return 0;
}