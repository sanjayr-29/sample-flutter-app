import 'dart:math';

import 'package:dummy_app/mobile_appbar.dart';
import 'package:dummy_app/mobile_bottombar.dart';
import 'package:dummy_app/scan_stepper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cropMap = {
    "Turmeric": {
      "crop_property": ["Powder Single Lot", "Finger"],
      "crop_pred_property": ["Curcumin", "Moisture", "Oleorisin", "Starch"],
      "predictions": [
        [4.46, 15.4, 16.95, 34],
        [4.48, 15.2, 17.02, 34.2],
        [4.47, 14.2, 16.92, 34.2],
      ],
    },
    "Chilli": {
      "crop_property": ["Sample Test", "Hello worldj"],
      "crop_pred_property": ["Red", "While", "Orange", "Pink"],
      "predictions": [
        [5.0, 3.0, 7.0, 2.0],
        [4.5, 3.5, 6.5, 2.5],
        [5.5, 2.5, 7.5, 1.5],
      ],
    },
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool scanStarted = false;
  bool scanEnded = false;
  String? _selectedCrop;
  String? _selectedCropProperty;

  // Each entry: { "label": "Iteration 1", "Curcumin": 3.45, ... }
  final List<Map<String, dynamic>> _scanRows = [];

  List<String> get _predProperties =>
      _selectedCrop != null
          ? List<String>.from(
            cropMap[_selectedCrop!]?["crop_pred_property"] ?? [],
          )
          : [];

  List<String> get _cropProperties =>
      _selectedCrop != null
          ? List<String>.from(cropMap[_selectedCrop!]?["crop_property"] ?? [])
          : [];

  Map<String, double> get _averages {
    if (_scanRows.isEmpty) return {};
    final avgs = <String, double>{};
    for (final prop in _predProperties) {
      final vals = _scanRows.map((r) => (r[prop] as double)).toList();
      avgs[prop] = vals.reduce((a, b) => a + b) / vals.length;
    }
    return avgs;
  }

  Map<String, dynamic> _generateScanValues() {
    final predictions = cropMap[_selectedCrop!]?["predictions"] as List?;
    final props = _predProperties;
    final row = <String, dynamic>{};

    if (predictions != null && predictions.isNotEmpty) {
      // Cycle through predefined rows if more scans than defined
      final predRow =
          predictions[_scanRows.length % predictions.length] as List;
      for (int i = 0; i < props.length; i++) {
        row[props[i]] = (predRow[i] as num).toDouble();
      }
    } else {
      // Fallback to random if no predictions defined
      final rng = Random();
      for (final prop in props) {
        row[prop] = double.parse((rng.nextDouble() * 10).toStringAsFixed(2));
      }
    }
    return row;
  }

  Future<void> _doScan() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => const AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Scanning…"),
              ],
            ),
          ),
    );
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.of(context).pop();
    setState(() {
      _scanRows.add(_generateScanValues());
    });
  }

  void _endScan() {
    setState(() {
      scanEnded = true;
      scanStarted = false;
    });
  }

  void _reset() {
    setState(() {
      scanStarted = false;
      scanEnded = false;
      _scanRows.clear();
    });
  }

  void _deleteRow(int index) {
    setState(() {
      _scanRows.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: MobileAppBar(title: "Home"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // ── Row 1: Sample Name & Sub-sample Name ──
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      enabled: !scanStarted,
                      decoration: const InputDecoration(
                        labelText: 'Sample Name',
                        hintText: 'Enter sample name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      enabled: !scanStarted,
                      decoration: const InputDecoration(
                        labelText: 'Sub-sample Name',
                        hintText: 'Enter sub-sample name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ── Row 2: Crop & Crop Property dropdowns ──
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCrop,
                      decoration: const InputDecoration(
                        labelText: 'Crop',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          cropMap.keys
                              .map(
                                (crop) => DropdownMenuItem(
                                  value: crop,
                                  child: Text(crop),
                                ),
                              )
                              .toList(),
                      onChanged:
                          scanStarted
                              ? null
                              : (value) {
                                setState(() {
                                  _selectedCrop = value;
                                  _selectedCropProperty = null;
                                });
                              },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCropProperty,
                      decoration: const InputDecoration(
                        labelText: 'Crop Property',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          _cropProperties
                              .where((p) => p.isNotEmpty)
                              .map(
                                (prop) => DropdownMenuItem(
                                  value: prop,
                                  child: Text(prop),
                                ),
                              )
                              .toList(),
                      onChanged:
                          _selectedCrop == null || scanStarted
                              ? null
                              : (value) {
                                setState(() => _selectedCropProperty = value);
                              },
                    ),
                  ),
                ],
              ),

              // ── Scan section ──
              if (scanStarted || scanEnded) ...[
                SizedBox(height: 20),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                  height: 20,
                ),

                // Averages tiles — shown after every scan iteration
                if (_scanRows.isNotEmpty) ...[
                  Center(
                    child: Text(
                      scanEnded ? "Final Result" : "Average Result",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(child: _buildAverageTiles()),
                  const SizedBox(height: 20),
                ],

                // Scan table header
                const SizedBox(height: 8),
                _buildScanTable(),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          scanStarted
              ? CustomScanFlowStepper(
                onClickAdd: _doScan,
                onClickFinish: _scanRows.length >= 3 ? _endScan : null,
                onClickAbort: _reset,
              )
              : MobileBottomBar(
                addCallback: () {
                  if (scanEnded) {
                    setState(() {
                      scanStarted = false;
                      scanEnded = false;
                      _scanRows.clear();
                      scanStarted = true;
                    });
                    return;
                  }
                  if (_selectedCrop == null || _selectedCropProperty == null) {
                    return;
                  }
                  setState(() => scanStarted = true);
                },
              ),
    );
  }

  Widget _buildScanTable() {
    if (_scanRows.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: Text(
            'No scans yet. Tap + to add a scan.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      children: [
        // Header row
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey)),
          ),
          child: Row(
            children: [
              _tableCell("S.No", isHeader: true, flex: 2),
              for (final p in _predProperties)
                _tableCell(p, isHeader: true, flex: 4),
              if (!scanEnded)
                _tableCell("", isHeader: true, flex: 2), // delete col header
            ],
          ),
        ),
        // Data rows
        for (int i = 0; i < _scanRows.length; i++)
          Row(
            children: [
              _tableCell("${i + 1}", flex: 2),
              for (final p in _predProperties)
                _tableCell(
                  (_scanRows[i][p] as double).toStringAsFixed(2),
                  flex: 4,
                ),
              if (!scanEnded)
                Expanded(
                  flex: 2,
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                    onPressed: () => _deleteRow(i),
                  ),
                ),
            ],
          ),
      ],
    );
  }

  Widget _tableCell(String text, {bool isHeader = false, int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            overflow: TextOverflow.ellipsis,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildAverageTiles() {
    final avgs = _averages;
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      runAlignment: WrapAlignment.spaceAround,
      children:
          avgs.entries.map((e) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.45,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      blurRadius: 6,
                      spreadRadius: 2,
                      offset: const Offset(2, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                ),
                height: 80,
                width: 80,
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      e.key,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      e.value.toStringAsFixed(2),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }
}
