import 'package:flutter/material.dart';
import 'package:nenas_kita/core/constants/enums.dart';

/// Dropdown for selecting Melaka district
class DistrictDropdown extends StatelessWidget {
  const DistrictDropdown({
    super.key,
    required this.value,
    this.onChanged,
    this.label = 'District',
    this.errorText,
    this.enabled = true,
  });

  /// Currently selected district
  final District? value;

  /// Callback when selection changes
  final ValueChanged<District?>? onChanged;

  /// Field label
  final String label;

  /// Error text to display
  final String? errorText;

  /// Enable/disable dropdown
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<District>(
      value: value,
      onChanged: enabled ? onChanged : null,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
      ),
      items: District.values.map((district) {
        return DropdownMenuItem<District>(
          value: district,
          child: Text(district.displayName),
        );
      }).toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select a district';
        }
        return null;
      },
    );
  }
}
