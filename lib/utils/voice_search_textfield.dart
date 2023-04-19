import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:yourteam/constants/colors.dart';
import 'package:yourteam/constants/constant_utils.dart';

class VoiceSearchTextField extends StatefulWidget {
  final Function onChanged;
  final FocusNode searchFieldFocusNode;
  final TextEditingController textEditingController;
  const VoiceSearchTextField(
      {required this.searchFieldFocusNode,
      required this.textEditingController,
      required this.onChanged,
      super.key});

  @override
  State<VoiceSearchTextField> createState() => _VoiceSearchTextFieldState();
}

class _VoiceSearchTextFieldState extends State<VoiceSearchTextField> {
  late stt.SpeechToText _speechToText;
  String _transcription = '';
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText();
  }

  void _startListening() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize(
        onError: (error) {
          showToastMessage(error.errorMsg);
        },
      );
      if (available) {
        widget.textEditingController.text = "Listening...";

        setState(() => _isListening = true);
        _speechToText.listen(
          onResult: (result) => setState(() {
            _transcription = result.recognizedWords;
            widget.textEditingController.text = _transcription;
            widget.onChanged(_transcription);
          }),
        );
      }
    }
  }

  void _stopListening() {
    if (_isListening) {
      setState(() => _isListening = false);
      _speechToText.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            focusNode: widget.searchFieldFocusNode,
            controller: widget.textEditingController,
            onChanged: (val) {
              widget.onChanged(val);
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: greyColor.withOpacity(0.1),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),
              suffixIcon: IconButton(
                icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                onPressed: () {
                  if (_isListening) {
                    _stopListening();
                  } else {
                    _startListening();
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
