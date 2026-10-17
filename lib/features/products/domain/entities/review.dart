import 'package:equatable/equatable.dart';

class Review extends Equatable {
  const Review({
    required this.rating,
    required this.comment,
    required this.reviewerName,
    this.date,
  });

  final int rating;
  final String comment;
  final String reviewerName;
  final DateTime? date;

  @override
  List<Object?> get props => [rating, comment, reviewerName, date];
}
