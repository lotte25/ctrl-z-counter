import 'package:flutter/material.dart';

class SessionDialog extends StatefulWidget {
  final String title;
  final String hintText;
  final String acceptButtonText;
  final String cancelButtonText;
  final Future<String?> Function(String value)? inputValidator;
  
  const SessionDialog({
    super.key, 
    required this.title, 
    required this.hintText, 
    this.acceptButtonText = "Accept", 
    this.cancelButtonText = "Cancel", 
    this.inputValidator
  });

  @override
  State<SessionDialog> createState() => _SessionDialogState();

  static Future<String?> show(
    BuildContext context, {
    required String title,
    required String hintText,
    String acceptButtonText = "Continue",
    String cancelButtonText = "Cancel",
    Future<String?> Function(String value)? inputValidator,
  }) {
    return showDialog(
      context: context, 
      builder: (context) => SessionDialog(
        title: title, 
        hintText: hintText,
        acceptButtonText: acceptButtonText,
        cancelButtonText: cancelButtonText,
        inputValidator: inputValidator,
      )
    );
  }
}

class _SessionDialogState extends State<SessionDialog> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  void _onSubmit() async {
    final value = _controller.text.trim();
    
    if (value.isEmpty) {
      setState(() {
        _errorText = "Please enter a name.";
      });
      return;
    }

    if (value.length > 32) {
      setState(() {
        _errorText = "Session name must be below 32 characters";
      });
      return;
    }

    if (value.length < 3) {
      setState(() {
        _errorText = "Session name must be above 3 characters";
      });
      return;
    }

    if (widget.inputValidator != null) {
      setState(() {
        _errorText = null;
      });

      final error = await widget.inputValidator!(value);

      setState(() {
        _errorText = error;
      });

      if (error != null) {
        return;
      }
    }

    if (mounted)  {
      Navigator.of(context).pop(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title, textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: widget.hintText,
              errorText: _errorText
            ),
            textAlign: TextAlign.center,
            autofocus: true,
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), 
          child: Text(widget.cancelButtonText)
        ),
        TextButton(
          onPressed: _onSubmit, 
          child: Text(widget.acceptButtonText)
        )
      ],
    );
  }
}