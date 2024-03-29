import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

void main() => runApp(MaterialApp(
  home: HAnim(),
  debugShowCheckedModeBanner: false,
));
class HAnim extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Physics(
        child: FlutterLogo(
          size: 150,
        )
      )),
    );
  }
}
class Physics extends StatefulWidget {
  final Widget child;
  Physics({this.child});
  @override
  _PhysicsState createState() => _PhysicsState();
}

class _PhysicsState extends State<Physics> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Alignment _dragAlignment = Alignment.center;
  Animation<Alignment> _animation;
  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;
      });
    });
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
   void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.center,
      ),
    );
  final unitsPerSecondX = pixelsPerSecond.dx / size.width;
  final unitsPerSecondY = pixelsPerSecond.dy / size.height;
  final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
  final unitVelocity = unitsPerSecond.distance;

  const spring = SpringDescription(
    mass: 30,
    stiffness: 1,
    damping: 1,
  );

  final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

  _controller.animateWith(simulation);
  //  _controller.reset();
  //  _controller.forward();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onPanDown: (details){
        _controller.stop();
      },
      onPanUpdate: (details){
        setState(() {
          _dragAlignment += Alignment(
          details.delta.dx / (size.width / 2),
          details.delta.dy / (size.height / 2),
         );
        });
      },
      onPanEnd: (details){
        _runAnimation(details.velocity.pixelsPerSecond, size);
      },
          child: Align(
            alignment: _dragAlignment,
        child: Card(
          child: widget.child,
        ),
      ),
    );
  }
}

 