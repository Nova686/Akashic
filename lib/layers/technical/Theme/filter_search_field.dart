import 'package:flutter/material.dart';

class FilterSearchField extends StatefulWidget {
  const FilterSearchField({required this.value, required this.onChanged, required this.hint, super.key});

  final String value;
  final ValueChanged<String> onChanged;
  final String hint;

  @override
  State<FilterSearchField> createState() => _FilterSearchFieldState();
}

class _FilterSearchFieldState extends State<FilterSearchField> {
  late final TextEditingController _controller = TextEditingController(text: widget.value);

  @override
  void didUpdateWidget(FilterSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: widget.hint,
          prefixIcon: const Icon(Icons.search),
          isDense: true,
          suffixIcon: widget.value.isEmpty ? null : IconButton(tooltip: MaterialLocalizations.of(context).deleteButtonTooltip, icon: const Icon(Icons.close), onPressed: () => widget.onChanged('')),
        ),
      );
}
