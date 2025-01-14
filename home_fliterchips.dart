import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venuebookingsystem/main.dart';
import 'package:venuebookingsystem/font.dart';
import 'package:venuebookingsystem/color_schemes.g.dart';
import 'package:venuebookingsystem/main.dart';
import 'package:provider/provider.dart';

class HomeFilterChips extends StatefulWidget {
  final Function(String)? onCategoryChanged;

  const HomeFilterChips({Key? key, this.onCategoryChanged}) : super(key: key);

  @override
  _HomeFilterChipsState createState() => _HomeFilterChipsState();
}

class _HomeFilterChipsState extends State<HomeFilterChips> {
  String _selectedCategory = 'classroom';

  Widget _filterchips(String text, String index) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    TextStyle? _getTextStyle(bool isSelected) {
      return isSelected
          ? textTheme.bodyMedium
              ?.copyWith(color: themeNotifier.colorScheme.onSurface)
          : textTheme.bodyMedium
              ?.copyWith(color: themeNotifier.colorScheme.onSurface);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: FilterChip(
        elevation: 0,
        label: Text(
          text,
          style: _getTextStyle(_selectedCategory == index),
        ),
        labelPadding: EdgeInsets.symmetric(vertical: 0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onSelected: (isSelected) {
          setState(() {
            _selectedCategory = index;
            if (widget.onCategoryChanged != null) {
              widget.onCategoryChanged!(_selectedCategory);
            }
          });
        },
        selected: _selectedCategory == index,
        checkmarkColor: themeNotifier.colorScheme.onSurface,
        selectedColor: themeNotifier.colorScheme.secondaryContainer,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Wrap(
          runSpacing: 10,
          children: [
            _filterchips('Classroom', 'classroom'),
            _filterchips('Hall', 'hall'),
            _filterchips('Playground', 'playground'),
            _filterchips('STEM Room', 'stem_room'),
            _filterchips('Computer Room', 'computer_room'),
          ],
        ),
      ),
    );
  }
}
