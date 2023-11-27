import 'package:flutter/material.dart';

class SlideAnimation  extends PageRouteBuilder{
  final page;

  SlideAnimation({required this.page}):super(pageBuilder:(context,animation,animationTo)=>page,transitionsBuilder:(context,animation,animationTo,child){

    // var begin=Offset(3,1);
    // var end=Offset(0,0);
    // var tween=Tween(begin: begin,end: end);
    // var curvesanimation=CurvedAnimation(parent:animation, curve: Curves.linear);
    // return SlideTransition(position: tween.animate(curvesanimation),child: child,);

    var begin=Offset(3,1);
    var end=Offset(0,0);
    var tween=Tween(begin: begin,end: end);
    var offsetanimation=animation.drive(tween);
    return SlideTransition(position:offsetanimation,child:child );


  });




}

class ScaleAnimation  extends PageRouteBuilder{
  final page;

  ScaleAnimation({required this.page}):super(pageBuilder:(context,animation,animationTo)=>page,transitionsBuilder:(context,animation,animationTo,child){
    var begin=0.0;
    var end=1.0;
    var tween=Tween(begin: begin,end: end);
    var curvesanimation=CurvedAnimation(parent:animation, curve: Curves.linearToEaseOut);
    return ScaleTransition(scale: tween.animate(curvesanimation),child:child,);

  });




}

class RotateAnimation  extends PageRouteBuilder{
  final page;

  RotateAnimation({required this.page}):super(pageBuilder:(context,animation,animationTo)=>page,transitionsBuilder:(context,animation,animationTo,child){

    var begin=0.0;
    var end=1.0;
    var tween=Tween(begin: begin,end: end);
    var curvesanimation=CurvedAnimation(parent:animation, curve: Curves.linearToEaseOut);
   return RotationTransition(turns: tween.animate(curvesanimation),child: child,);

  });




}



class SizedAnimation  extends PageRouteBuilder{
  final page;

  SizedAnimation({required this.page}):super(pageBuilder:(context,animation,animationTo)=>page,transitionsBuilder:(context,animation,animationTo,child){
    return Align(alignment: Alignment.center,child: SizeTransition(sizeFactor:animation,child: child,),);
  });




}

class FadeAnimation  extends PageRouteBuilder{
  final page;

  FadeAnimation({required this.page}):super(pageBuilder:(context,animation,animationTo)=>page,transitionsBuilder:(context,animation,animationTo,child){
    return FadeTransition(opacity:animation,child: child,);
  });




}



class ScaleRotateAnimation  extends PageRouteBuilder{
  final page;


  ScaleRotateAnimation({required this.page}):super(pageBuilder:(context,animation,animationTo)=>page,transitionsBuilder:(context,animation,animationTo,child){
    var begin=0.0;
    var end=1.0;
    var tween=Tween(begin: begin,end: end);
    var curvesanimation=CurvedAnimation(parent:animation, curve: Curves.linearToEaseOut);

    return RotationTransition(turns: animation,child: ScaleTransition(
      scale: tween.animate(curvesanimation),child:child
    ),);
  });




}


class TransformAnimation{


  static Scale(Widget child)
  {
    return Transform.scale(scale:3 ,child:child,origin: Offset(0,0),);
  }

  static translate(Widget child)
  {
    return Transform.translate(offset:Offset(10,10) ,child:child);
  }

  static rotate(Widget child)
  {
    return Transform.rotate(angle: 45,origin:Offset(12,0),child:child);
  }

  static matrix(Widget child)
  {
    return Transform(transform: Matrix4.rotationZ(3.14/4)..scale(3.0)..translate(4.0,5.0),);
  }
}

class AnimatedContainer_An{

  static animatedContainer(Widget child)
  {
    return AnimatedContainer(
     // color: Colors.red,
      ///curve: Curves.easeInBack,
      onEnd: (){

      },
      duration: Duration(seconds: 3),
     // transform: Matrix4.rotationZ(3.14/4),
      child: child,
    );

  }
}

class AnimatedCross_An{

  static animatedCross()
  {
    return AnimatedCrossFade(
      firstChild: Container(color: Colors.red,width: 300,height: 300),
      secondChild:Container(color: Colors.green,width: 100,height: 100),
      crossFadeState: CrossFadeState.showFirst,
      duration: Duration(seconds: 1),
     );

  }
}


class TextStyleAnimation {
  double fontSize;
  String text;

  TextStyleAnimation(this.fontSize,this.text);

  animate()
  {
    return AnimatedDefaultTextStyle(
      child:Text(text) ,
      style: TextStyle(fontWeight: FontWeight.bold,fontSize:fontSize>0?fontSize: 20,color: Colors.white,fontFamily:'AbyssinicaSIL-Regular'),
      duration: Duration(seconds: 1),
    );
  }

}


class PhisicalModelAnimation{

  static animate()
  {
    return AnimatedPhysicalModel(
        child: Container(height: 100,width: 100,),
        shape: BoxShape.circle,
        elevation: 30,
        color: Colors.green,
        shadowColor: Colors.black,
        duration: Duration(seconds: 1)
    );
  }
}

class ExplistityAnimate extends StatefulWidget {
  double begin,end;
  int direction;

    ExplistityAnimate(this.begin,this.end, this.direction,{super.key});

  @override
  State<ExplistityAnimate> createState() => _ExplistityAnimateState();
}

class _ExplistityAnimateState extends State<ExplistityAnimate>with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  double val=0.0 ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller=AnimationController(vsync: this,duration: Duration(seconds: 100));
    animation=Tween(begin:widget.begin,end: widget.end).animate(controller);

    animation.addStatusListener((status) { print(status);});
    animation.addListener(() {

      setState(() {

      });
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return   Center(
        child:Transform.rotate(
            angle: 3.14/2*animation.value*widget.direction,
            child: Container(height: 100,width: 100,color: Colors.indigo,),
        )
    );
  }
}

