import 'dart:convert';

class VideoDetails {
  final Error? error;
  final List<dynamic>? programs;
  final List<Stream>? streams;
  final Format? format;

  VideoDetails({
    this.error,
    this.programs,
    this.streams,
    this.format,
  });

  factory VideoDetails.fromRawJson(String str) =>
      VideoDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VideoDetails.fromJson(Map<String, dynamic> json) => VideoDetails(
        error: json["error"] == null ? null : Error.fromJson(json["error"]),
        programs: json["programs"] == null
            ? []
            : List<dynamic>.from(json["programs"]!.map((x) => x)),
        streams: json["streams"] == null
            ? []
            : List<Stream>.from(
                json["streams"]!.map((x) => Stream.fromJson(x))),
        format: json["format"] == null ? null : Format.fromJson(json["format"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error?.toJson(),
        "programs":
            programs == null ? [] : List<dynamic>.from(programs!.map((x) => x)),
        "streams": streams == null
            ? []
            : List<dynamic>.from(streams!.map((x) => x.toJson())),
        "format": format?.toJson(),
      };
}

class Error {
  final int? code;
  final String? string;

  Error({
    this.code,
    this.string,
  });

  factory Error.fromRawJson(String str) => Error.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        code: json["code"],
        string: json["string"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "string": string,
      };
}

class Format {
  final String? filename;
  final int? nbStreams;
  final String? formatName;
  final String? formatLongName;
  final String? duration;
  final String? size;
  final String? bitRate;
  final Tags? tags;

  Format({
    this.filename,
    this.nbStreams,
    this.formatName,
    this.formatLongName,
    this.duration,
    this.size,
    this.bitRate,
    this.tags,
  });

  factory Format.fromRawJson(String str) => Format.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Format.fromJson(Map<String, dynamic> json) => Format(
        filename: json["filename"],
        nbStreams: json["nb_streams"],
        formatName: json["format_name"],
        formatLongName: json["format_long_name"],
        duration: json["duration"],
        size: json["size"],
        bitRate: json["bit_rate"],
        tags: json["tags"] == null ? null : Tags.fromJson(json["tags"]),
      );

  Map<String, dynamic> toJson() => {
        "filename": filename,
        "nb_streams": nbStreams,
        "format_name": formatName,
        "format_long_name": formatLongName,
        "duration": duration,
        "size": size,
        "bit_rate": bitRate,
        "tags": tags?.toJson(),
      };
}

class Tags {
  final DateTime? creationTime;

  Tags({
    this.creationTime,
  });

  factory Tags.fromRawJson(String str) => Tags.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Tags.fromJson(Map<String, dynamic> json) => Tags(
        creationTime: json["creation_time"] == null
            ? null
            : DateTime.parse(json["creation_time"]),
      );

  Map<String, dynamic> toJson() => {
        "creation_time": creationTime?.toIso8601String(),
      };
}

class Stream {
  final int? index;
  final String? codecName;
  final String? codecLongName;
  final String? codecType;
  final String? codecTagString;
  final int? width;
  final int? height;
  final String? displayAspectRatio;
  final String? colorRange;
  final String? rFrameRate;
  final String? duration;
  final String? bitRate;
  final Tags? tags;
  final String? sampleRate;
  final int? channels;

  Stream({
    this.index,
    this.codecName,
    this.codecLongName,
    this.codecType,
    this.codecTagString,
    this.width,
    this.height,
    this.displayAspectRatio,
    this.colorRange,
    this.rFrameRate,
    this.duration,
    this.bitRate,
    this.tags,
    this.sampleRate,
    this.channels,
  });

  factory Stream.fromRawJson(String str) => Stream.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Stream.fromJson(Map<String, dynamic> json) => Stream(
        index: json["index"],
        codecName: json["codec_name"],
        codecLongName: json["codec_long_name"],
        codecType: json["codec_type"],
        codecTagString: json["codec_tag_string"],
        width: json["width"],
        height: json["height"],
        displayAspectRatio: json["display_aspect_ratio"],
        colorRange: json["color_range"],
        rFrameRate: json["r_frame_rate"],
        duration: json["duration"],
        bitRate: json["bit_rate"],
        tags: json["tags"] == null ? null : Tags.fromJson(json["tags"]),
        sampleRate: json["sample_rate"],
        channels: json["channels"],
      );

  Map<String, dynamic> toJson() => {
        "index": index,
        "codec_name": codecName,
        "codec_long_name": codecLongName,
        "codec_type": codecType,
        "codec_tag_string": codecTagString,
        "width": width,
        "height": height,
        "display_aspect_ratio": displayAspectRatio,
        "color_range": colorRange,
        "r_frame_rate": rFrameRate,
        "duration": duration,
        "bit_rate": bitRate,
        "tags": tags?.toJson(),
        "sample_rate": sampleRate,
        "channels": channels,
      };
}
