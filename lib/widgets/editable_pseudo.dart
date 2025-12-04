import 'package:flutter/material.dart';
import 'package:nds_gui_kit/widgets/text.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kPseudoKey = 'nds_pseudo';
const String _kDefaultPseudo = 'Hello';

class NDSEditablePseudo extends StatefulWidget {
  const NDSEditablePseudo({super.key});

  @override
  State<NDSEditablePseudo> createState() => _NDSEditablePseudoState();
}

class _NDSEditablePseudoState extends State<NDSEditablePseudo> {
  String _pseudo = _kDefaultPseudo;

  @override
  void initState() {
    super.initState();
    _loadPseudo();
  }

  Future<void> _loadPseudo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pseudo = prefs.getString(_kPseudoKey) ?? _kDefaultPseudo;
    });
  }

  Future<void> _savePseudo(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPseudoKey, value);
    setState(() {
      _pseudo = value;
    });
  }

  void _showEditDialog() {
    final controller = TextEditingController(text: _pseudo);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('Edit Pseudo', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter your pseudo',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              _savePseudo(value);
            }
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _savePseudo(controller.text);
              }
              Navigator.of(context).pop();
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showEditDialog,
      child: NDSText(text: _pseudo),
    );
  }
}
