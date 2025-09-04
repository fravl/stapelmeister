class ScoreService {
  int _score = 0;

  int get score => _score;

  void reset() => _score = 0;
  void increment([int amount = 1]) => _score += amount;
}