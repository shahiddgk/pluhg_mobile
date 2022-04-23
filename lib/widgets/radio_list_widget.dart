import 'package:flutter/material.dart';

  class RadioListTitleComponent<T> extends StatelessWidget {
  final T value;
  final String label;
  final bool isChecked;
  final ValueChanged<T> itemSelected;

  RadioListTitleComponent({
    required this.value,
    required this.label,
    required this.itemSelected,
    this.isChecked = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30.0),
      onTap: () => itemSelected(this.value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  isChecked
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: isChecked ? Theme.of(context).primaryColor : null,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  label,
                ),
              ],
            ),



          ],
        ),
      ),
    );
  }
}
