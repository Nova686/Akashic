import 'package:flutter/material.dart';

class LabeledTextEntry extends StatefulWidget {
  const LabeledTextEntry({required this.hint, required this.actionLabel, required this.onSubmitted, super.key});

  final String hint;
  final String actionLabel;
  final ValueChanged<String> onSubmitted;

  @override
  State<LabeledTextEntry> createState() => _LabeledTextEntryState();
}

class _LabeledTextEntryState extends State<LabeledTextEntry> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    widget.onSubmitted(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(hintText: widget.hint),
          onSubmitted: (_) => _submit(),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(onPressed: _submit, icon: const Icon(Icons.add), label: Text(widget.actionLabel)),
        ),
      ],
    );
  }
}
