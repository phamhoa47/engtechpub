class UserStatus {
  int diamonds;
  int hearts;

  UserStatus({this.diamonds = 0, this.hearts = 3});

  void loseHeart() {
    if (hearts > 0) hearts--;
  }

  void gainHeart() {
    if (hearts < 3) hearts++;
  }

  bool useDiamonds(int amount) {
    if (diamonds >= amount) {
      diamonds -= amount;
      return true;
    }
    return false;
  }

  void earnDiamonds(int amount) {
    diamonds += amount;
  }
}
