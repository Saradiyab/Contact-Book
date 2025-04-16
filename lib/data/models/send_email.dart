class EmailModel {
  final String to;
  final String cc;
  final String bcc;
  final String subject;
  final String body;

  EmailModel({
    required this.to,
    required this.cc,
    required this.bcc,
    required this.subject,
    required this.body,
  });

  // JSON'dan nesneye dönüştürme
  factory EmailModel.fromJson(Map<String, dynamic> json) {
    return EmailModel(
      to: json['to'] ?? '',
      cc: json['cc'] ?? '',
      bcc: json['bcc'] ?? '',
      subject: json['subject'] ?? '',
      body: json['body'] ?? '',
    );
  }

  // Nesneden JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'to': to,
      'cc': cc,
      'bcc': bcc,
      'subject': subject,
      'body': body,
    };
  }
}
