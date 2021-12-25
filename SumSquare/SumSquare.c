int SumSquare(int n) {
    if (n <= 1) return n;
    return n * n + SumSquare(n - 1);
}

int main() {
    SumSquare(3);
    return 0;
}