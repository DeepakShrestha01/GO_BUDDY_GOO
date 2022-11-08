// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_detail.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDetailAdapter extends TypeAdapter<UserDetail> {
  @override
  final int typeId = 2;

  @override
  UserDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDetail()
      ..name = fields[0] as String?
      ..contact = fields[1] as String?
      ..status = fields[2] as int?
      ..address = fields[3] as String?
      ..country = fields[4] as String?
      ..gender = fields[5] as String?
      ..dob = fields[6] as String?
      ..image = fields[7] as String?
      ..reward = fields[8] as double?
      ..socialProfilePic = fields[9] as String?
      ..isVerified = fields[10] as bool?;
  }

  @override
  void write(BinaryWriter writer, UserDetail obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.contact)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.country)
      ..writeByte(5)
      ..write(obj.gender)
      ..writeByte(6)
      ..write(obj.dob)
      ..writeByte(7)
      ..write(obj.image)
      ..writeByte(8)
      ..write(obj.reward)
      ..writeByte(9)
      ..write(obj.socialProfilePic)
      ..writeByte(10)
      ..write(obj.isVerified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
