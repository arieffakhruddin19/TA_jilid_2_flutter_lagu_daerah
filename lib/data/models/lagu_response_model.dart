import 'dart:convert';

class LaguResponseModel {
  final String status;
  final Data data;

  LaguResponseModel({
    required this.status,
    required this.data,
  });

  factory LaguResponseModel.fromJson(String str) =>
      LaguResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LaguResponseModel.fromMap(Map<String, dynamic> json) =>
      LaguResponseModel(
        status: json["status"],
        data: Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "data": data.toMap(),
      };
}

class Data {
  final int currentPage;
  final List<Lagu> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<Link> links;
  final dynamic nextPageUrl;
  final String path;
  final int perPage;
  final String prevPageUrl;
  final int to;
  final int total;

  Data({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        data: List<Lagu>.from(json["data"].map((x) => Lagu.fromMap(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromMap(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"] ?? '',
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toMap() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toMap())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Lagu {
  final int id;
  final String judul;
  final String lagu;
  final String daerah;
  final String videoUrl;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Lagu({
    required this.id,
    required this.judul,
    required this.lagu,
    required this.daerah,
    required this.videoUrl,
    required this.createdAt,
    required this.updatedAt,
    this.imageUrl,
  });

  factory Lagu.fromJson(String str) => Lagu.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Lagu.fromMap(Map<String, dynamic> json) => Lagu(
        id: json["id"],
        judul: json["judul"],
        lagu: json["lagu"],
        daerah: json["daerah"],
        videoUrl: json["video_url"],
        imageUrl: json["image_url"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "judul": judul,
        "lagu": lagu,
        "daerah": daerah,
        "video_url": videoUrl,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Link {
  final String url;
  final String label;
  final bool active;

  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(String str) => Link.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Link.fromMap(Map<String, dynamic> json) => Link(
        url: json["url"] ?? '',
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toMap() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
