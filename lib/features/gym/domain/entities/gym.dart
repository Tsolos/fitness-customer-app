import 'package:equatable/equatable.dart';

/// One row from `GET /api/Auth/gyms` — a company the app can log into.
class Gym extends Equatable {
  const Gym({required this.id, required this.title});

  final String id;
  final String title;

  @override
  List<Object?> get props => [id, title];
}
