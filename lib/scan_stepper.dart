import 'package:flutter/material.dart';

class CustomScanFlowStepper extends StatefulWidget {
  const CustomScanFlowStepper({
    super.key,
    required this.onClickAdd,
    this.onClickFinish,
    required this.onClickAbort,
  });

  final VoidCallback onClickAdd;
  final VoidCallback? onClickFinish;
  final VoidCallback onClickAbort;

  @override
  State<CustomScanFlowStepper> createState() => _CustomScanFlowStepperState();
}

class _CustomScanFlowStepperState extends State<CustomScanFlowStepper> {
  @override
  Widget build(BuildContext context) {
    const green = Color.fromRGBO(13, 129, 65, 1);
    final btnShape = ButtonStyle(
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.grey.shade300;
        }
        return null; // use default tonal color
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.grey.shade500;
        }
        return null;
      }),
    );

    return BottomAppBar(
      height: 64,
      color: green,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Row(
        children: [
          // Abort
          Expanded(
            child: FilledButton.tonal(
              style: btnShape,
              onPressed: widget.onClickAbort,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.close, size: 18, color: Colors.red),
                  SizedBox(width: 6),
                  Text("Abort"),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FilledButton.tonal(
              style: btnShape,
              onPressed: widget.onClickFinish,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check, size: 18, color: green),
                  SizedBox(width: 6),
                  Text("Finish"),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FilledButton.tonal(
              style: btnShape,
              onPressed: widget.onClickAdd,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Add"),
                  SizedBox(width: 6),
                  Icon(Icons.add, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
