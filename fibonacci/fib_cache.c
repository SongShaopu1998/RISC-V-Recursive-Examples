#include<stdio.h>
#include <stdlib.h>

#define MAX 31

int cache[MAX];

int find(int num) {
    return cache[num];
}

int fib(int n) {
    if (n <= 1) return n;
    int cache_result = find(n);
    if (cache_result != -1) return cache_result;
    cache[n] = fib(n - 1) + fib(n - 2);
    return cache[n];
}

int main(int argc, char *argv[]) {
    for (int i = 0; i < MAX; ++i) {
        cache[i] = -1;
    }
    // char-->int
    int num = atoi(argv[1]);
    printf("num: %d\n", num);
    printf("result: %d\n", fib(num));
    return 0;
}
