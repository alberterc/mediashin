class MediashinFunction {
  final int id;
  final String name;
  final String desc;

  const MediashinFunction(this. id, this.name, this.desc);
}

final List<MediashinFunction> pages = [
  const MediashinFunction(0, 'Analyze', 'Get info about the video.'),
  const MediashinFunction(1, 'Compress', 'Compress large video smaller in size.'),
  const MediashinFunction(2, 'Convert', 'Convert video into another encoding.'),
  const MediashinFunction(3, 'Extract', 'Extract audio from video.'),
  const MediashinFunction(4, 'Extract1', 'Extract subtitles from video.'),
  const MediashinFunction(5, 'Extract2', 'Extract images from video.'),
  const MediashinFunction(6, 'Extract3', 'Extract thumbnail from video.'),
  const MediashinFunction(7, 'Extract4', 'Extract video metadata.'),
  const MediashinFunction(8, 'Extract5', 'Extract audio metadata.'),
  const MediashinFunction(9, 'Extract6', 'Extract subtitle metadata.'),
];