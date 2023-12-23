class Messages{
  int? id;
  final String content;
  final String type ;
  final int Sid;
  final int Rid;
  final DateTime date;
  int? relationID;

  Messages(this.content, this.type, this.Sid, this.Rid, this.date,this.relationID);

  Messages.idMessage(this.id,this.content, this.type, this.Sid, this.Rid, this.date,this.relationID);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type,
      'Sid': Sid,
      'Rid': Rid,
      'date': date,
    };
  }

    Map<String, dynamic> toSend() {
      return {
        'content': content,
        'type': type,
        'Sid': Sid,
        'Rid': Rid,
        'date':date.toString(),
        'relationID':relationID
      };
    }

  factory Messages.fromJson(Map<String, dynamic> json) {
    return Messages.idMessage(
      int.parse(json['ID']),
      json['Content'],
      json['type'],
      int.parse(json['Sid']),
      int.parse(json['Rid']),
      DateTime.parse(json['Date']),
      int.parse(json['relationId']),

    );
  }

}