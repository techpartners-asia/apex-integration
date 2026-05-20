part of '../user_entity_dto.dart';

/// File metadata returned by backend profile/account endpoints.
///
/// Used for profile images and saved signature files. The backend currently
/// spells `extention` this way, so the DTO preserves that field name.
class FileEntity {
  /// File identifier.
  final int? id;

  /// Stored file name.
  final String? fileName;

  /// Original uploaded file name.
  final String? originalName;

  /// Backend physical path or URL-like storage path.
  final String? physicalPath;

  /// File extension value from the backend.
  final String? extention;

  /// File size as reported by the backend.
  final num? fileSize;

  /// Raw creation timestamp.
  final String? createdAt;

  /// Raw update timestamp.
  final String? updatedAt;

  /// Creates a backend file entity DTO.
  const FileEntity({
    this.id,
    this.fileName,
    this.originalName,
    this.physicalPath,
    this.extention,
    this.fileSize,
    this.createdAt,
    this.updatedAt,
  });

  /// Parses backend file metadata with nullable fields for old responses.
  factory FileEntity.fromJson(Map<String, Object?> json) {
    return FileEntity(
      id: ApiParser.asNullableInt(json['id']),
      fileName: ApiParser.asNullableString(json['file_name']),
      originalName: ApiParser.asNullableString(json['original_name']),
      physicalPath: ApiParser.asNullableString(json['physical_path']),
      extention: ApiParser.asNullableString(json['extention']),
      fileSize: ApiParser.asNullableDouble(json['file_size']),
      createdAt: ApiParser.asNullableString(json['created_at']),
      updatedAt: ApiParser.asNullableString(json['updated_at']),
    );
  }

  /// Returns a copy with selected fields replaced.
  FileEntity copyWith({
    int? id,
    String? fileName,
    String? originalName,
    String? physicalPath,
    String? extention,
    num? fileSize,
    String? createdAt,
    String? updatedAt,
  }) {
    return FileEntity(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      originalName: originalName ?? this.originalName,
      physicalPath: physicalPath ?? this.physicalPath,
      extention: extention ?? this.extention,
      fileSize: fileSize ?? this.fileSize,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
