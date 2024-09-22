class VideoDetails {
  VideoDetails({
    required this.name,
    required this.desc
  });

  final String name;
  final String desc;

  factory VideoDetails.fromJson(Map<String, String> json) {
    return VideoDetails(
      name: json['name']!,
      desc: json['desc']!
    );
  }
}

final List<VideoDetails> simpleVideoDetails = [
  VideoDetails(name: 'Filename', desc: 'Name of the file'),
  VideoDetails(name: 'Duration', desc: 'Length of the video'),
  VideoDetails(name: 'Format', desc: 'Format of the video'),
  VideoDetails(name: 'Codec', desc: 'Codec of the video'),
  VideoDetails(name: 'Resolution', desc: 'Resolution of the video'),
  VideoDetails(name: 'Bitrate', desc: 'Bitrate of the video'),
  VideoDetails(name: 'Size', desc: 'Size of the video'),
  VideoDetails(name: 'Streams', desc: 'Streams of the video'),
  VideoDetails(name: 'Created Time', desc: 'Created Time of the video')
];