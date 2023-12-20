class Messages{
  int? id;
  final String content;
  final String type ;
  final int Sid;
  final int Rid;
  final DateTime date;

  Messages(this.content, this.type, this.Sid, this.Rid, this.date);

  Messages.idMessage(this.id,this.content, this.type, this.Sid, this.Rid, this.date);

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

  factory Messages.fromJson(Map<String, dynamic> json) {
    return Messages.idMessage(
      json['id'],
      json['content'],
      json['type'],
      json['Sid'],
      json['Rid'],
      DateTime.parse(json['date']),
    );
  }

}