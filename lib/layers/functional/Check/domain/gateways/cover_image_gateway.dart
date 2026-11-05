import 'package:equatable/equatable.dart';

class StoredCover extends Equatable {
  const StoredCover({required this.path, this.spineColorValue});

  final String path;
  final int? spineColorValue;

  @override
  List<Object?> get props => [path, spineColorValue];
}

abstract interface class CoverImageGateway {
  Future<StoredCover?> storeCover(String url);
}
