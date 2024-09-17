import 'package:fluent_ui/fluent_ui.dart';

import '../components/window_title_bar.dart';

class AnalyzePage extends StatelessWidget {
  const AnalyzePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WindowTitleBar(
          backButton: true,
          title: 'Analyze',
        ),
        _buildBody(context)
      ],
    );
  }
  
  Widget _buildBody(BuildContext context) {
    return const Text('Analyze Page');
  }
}