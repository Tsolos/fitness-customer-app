import '../../../../core/utils/json_parsing.dart';
import '../../domain/entities/gym.dart';

class GymModel {
  const GymModel({required this.id, required this.title});

  final String id;
  final String title;

  factory GymModel.fromJson(Map<String, dynamic> json) {
    return GymModel(
      id: parseString(json['companyID']),
      title: parseString(json['title'], fallback: 'Γυμναστήριο'),
    );
  }

  Gym toEntity() => Gym(id: id, title: title);
}
