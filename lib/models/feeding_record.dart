class FeedingRecord {
  final int id;
  final int petId;
  final String foodType;
  final String mealTime;
  final double amount;
  final bool drankWater;

  FeedingRecord({
    required this.id,
    required this.petId,
    required this.foodType,
    required this.mealTime,
    required this.amount,
    required this.drankWater,
  });
}
