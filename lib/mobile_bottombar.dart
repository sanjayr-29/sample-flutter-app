import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

class MobileBottomBar extends StatelessWidget {
  final VoidCallback? addCallback;

  const MobileBottomBar({super.key, this.addCallback});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return SizedBox(
      width: size.width,
      height: 80,
      child: Stack(
        children: [
          CustomPaint(size: Size(size.width, 80), painter: BNBCustomPainter()),
          Center(
            heightFactor: 0.6,
            child: FloatingActionButton(
              shape: CircleBorder(),
              onPressed: addCallback,
              backgroundColor: Colors.white,
              child: Icon(EvaIcons.plus),
            ),
          ),
          SizedBox(
            width: size.width,
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                navItem(
                  onPressed: () {
                    context.go('/');
                  },
                  icon: Icons.home,
                  title: "Home",
                ),
                navItem(onPressed: () {}, icon: Icons.cloud, title: "Cloud"),
                Container(width: size.width * .2),
                navItem(
                  onPressed: () => context.go('/device'),
                  icon: Icons.settings,
                  title: "Device",
                ),
                navItem(onPressed: () {}, icon: Icons.person, title: "Info"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget navItem({
    required VoidCallback onPressed,
    required IconData icon,
    required String title,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: FittedBox(
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            Text(title, style: TextStyle(color: Colors.white, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint =
        Paint()
          ..color = Color.fromRGBO(13, 129, 65, 1)
          ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 10);
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 10);
    path.arcToPoint(
      Offset(size.width * 0.60, 20),
      radius: Radius.circular(20.0),
      clockwise: false,
    );
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 10);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width, 10);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 10);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
