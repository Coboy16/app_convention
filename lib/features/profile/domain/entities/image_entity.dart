import 'package:equatable/equatable.dart';

class ImageEntity extends Equatable {
  final String id;
  final String localPath;
  final String? url;
  final bool isUploaded;

  const ImageEntity({
    required this.id,
    required this.localPath,
    this.url,
    this.isUploaded = false,
  });

  ImageEntity copyWith({
    String? id,
    String? localPath,
    String? url,
    bool? isUploaded,
  }) {
    return ImageEntity(
      id: id ?? this.id,
      localPath: localPath ?? this.localPath,
      url: url ?? this.url,
      isUploaded: isUploaded ?? this.isUploaded,
    );
  }

  @override
  List<Object?> get props => [id, localPath, url, isUploaded];
}
