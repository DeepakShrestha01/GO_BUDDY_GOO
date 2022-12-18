
import 'dart:convert';

SelectBusResponse selectBusResponseFromJson(String str) => SelectBusResponse.fromJson(json.decode(str));

String selectBusResponseToJson(SelectBusResponse data) => json.encode(data.toJson());

class SelectBusResponse {
    SelectBusResponse({
        this.status,
        this.detail,
    });

    bool ?status;
    Detail ?detail;

    factory SelectBusResponse.fromJson(Map<String, dynamic> json) => SelectBusResponse(
        status: json["status"],
        detail: Detail.fromJson(json["detail"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "detail": detail?.toJson(),
    };
}

class Detail {
    Detail({
        this.boardingPoint,
        this.ticketSerialNo,
    });

    List<String>? boardingPoint;
    String ?ticketSerialNo;

    factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        boardingPoint: List<String>.from(json["boarding_point"].map((x) => x)),
        ticketSerialNo: json["ticket_serial_no"],
    );

    Map<String, dynamic> toJson() => {
        "boarding_point": List<dynamic>.from(boardingPoint!.map((x) => x)),
        "ticket_serial_no": ticketSerialNo,
    };
}
