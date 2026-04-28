part of '../user_entity_dto.dart';

class FileEntity {
  final int? id;
  final String? fileName;
  final String? originalName;
  final String? physicalPath;
  final String? extention;
  final num? fileSize;
  final String? createdAt;
  final String? updatedAt;

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
