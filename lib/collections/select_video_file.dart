import 'package:file_picker/file_picker.dart';

Future<String> selectVideoFile() async {
  FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
      withData: false,
      withReadStream: false
    );

    if (filePickerResult != null) {
      return filePickerResult.files.first.path!;
    }
    return '';
}