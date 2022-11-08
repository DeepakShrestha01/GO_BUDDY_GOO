import 'dart:convert';

class BusSeat {
  int? id;
  String? name;
  String? status;
  bool? canBeSelected;
  String? compartment;
  BusSeat({
    required this.id,
    required this.name,
    required this.status,
  }) {
    canBeSelected = status == "SL";
    if (name!.toLowerCase().contains("c")) {
      compartment = "c_compartment";
    } else if (name!.toLowerCase().contains("a")) {
      compartment = "a_compartment";
    } else if (name!.toLowerCase().contains("b")) {
      compartment = "b_compartment";
    } else if (name!.toLowerCase().contains("l")) {
      compartment = "l_compartment";
    } else {
      compartment = "none";
    }
  }

  BusSeat copyWith({
    int? id,
    String? name,
    String ?status,
    bool? canBeSelected,
    String ?compartment,
  }) {
    return BusSeat(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'canBeSelected': canBeSelected,
      'compartment': compartment,
    };
  }

  factory BusSeat.fromMap(Map<String, dynamic> map) {
    return BusSeat(
      id: map['id'],
      name: map['name'],
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BusSeat.fromJson(String source) =>
      BusSeat.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BusSeat(id: $id, name: $name, status: $status, canBeSelected: $canBeSelected, compartment: $compartment)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BusSeat &&
        other.id == id &&
        other.name == name &&
        other.status == status &&
        other.canBeSelected == canBeSelected &&
        other.compartment == compartment;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        status.hashCode ^
        canBeSelected.hashCode ^
        compartment.hashCode;
  }
}
