String two(int n) => n.toString().padLeft(2, '0');
int minutesOf(int s) => s ~/ 60;
int secondsRemainder(int s) => s % 60;