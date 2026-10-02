import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.userName,
    required this.avatarUrl,
    required this.role,
  });

  final String id;
  final String userName;
  final String? avatarUrl;
  final String role;

  @override
  List<Object?> get props => [id, userName, avatarUrl, role];
}
