
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import "dart:ui";
import "dart:math";
 
void main() {
  // main method thats
  // run the RunMyApp
  runApp(RunMyApp());  
}
 
class RunMyApp extends StatelessWidget {
  const RunMyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    // materialApp with debugbanner false
    return MaterialApp( 
      title: "Backgammon",
      // theme of the app
      theme: ThemeData(primarySwatch: Colors.green), 
      // scaffold with app
      home: MyInteractiveWidget(child: MyPainter()),
    );
  }
}

class MyInteractiveWidget extends StatelessWidget{
  final Widget child;

  const MyInteractiveWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTapDown: (coordinates){
        (child as MyPainter).handleTap(coordinates.globalPosition);
      },
      child: child,
    );
  }
}


  List<int> whiteStones = [
    24,24,
    13,13,13,13,13,
    8,8,8,
    6,6,6,6,6
  ];

  List <int> blackStones = [
    1,1,
    12,12,12,12,12,
    17,17,17,
    19,19,19,19,19,
  ];

  List <int> blackStonesTest = [
    4,4,4,4,4
  ];
  List <int> whiteStonesTest = [
    15,15,15,15,
  ];




BackgroundPainter myBackGroundPainter = BackgroundPainter();
StonesPainter BlackStonesPainter = StonesPainter(Colors.black, whiteStones);
StonesPainter WhiteStonesPainter = StonesPainter(Colors.red, blackStones);


class MyPainter extends StatelessWidget{
  String RNG(){
    var rng = Random();
    String randomString = (rng.nextInt(6)+1).toString();
    return randomString;
  }

  void handleTap(Offset tapPosition){
    print(tapPosition);
    print("AAAAAAAAAAAAA");

    //find out what point was touched
    Map pointsMap = myBackGroundPainter.PointsMap;
    double pointWidth = myBackGroundPainter.PointWidth;
    double canvasHeight = myBackGroundPainter.sizeHeight;



    Map pointsMapTouch = Map<int, List>();
    for (int i = 1; i <= pointsMap.length; i++){
      double point = pointsMap[i];
      pointsMapTouch[i] = [point-pointWidth/2, point+pointWidth/2];
    }
    int touchedPoint = 0;
    for (int i = 1; i <= pointsMapTouch.length; i++){
      if (tapPosition.dx > pointsMapTouch[i][0] && tapPosition.dx < pointsMapTouch[i][1]){
        if (tapPosition.dy < canvasHeight/2){
          touchedPoint = 25-i;
        } else{
          touchedPoint = i;
        }
        print("Sie haben Punkt $touchedPoint berührt");
        break;
      }
    }





  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CustomPaint(
        painter: myBackGroundPainter,
        child: Container(), 
      ),
      CustomPaint(
        painter:BlackStonesPainter,
        foregroundPainter: WhiteStonesPainter
        ),
      Align(
        alignment: Alignment(-0.5, 0),
        child: CustomPaint(
          painter: dicePainter(),
          child: Text(RNG()),
        ),
      ),
      Align( 
      alignment: Alignment(-0.3,0),
      child: CustomPaint(
        painter: dicePainter(),
        child: Text(RNG()),
      ),
      ),    
    ]);
  }
}
// A backgammon board has 6 triangles per side
// they should use the whole screen minus the width of the bar
// and the width of the left and right side. 
// we will use almost no space an the left side and display all
// the relevant data on the right side. 
// The height of the points will be Screensize - middle_distance
// divided by 2.
// paints backgammon board

  int bottomWidth = 40;
  double topWidth = 40;


class BackgroundPainter extends CustomPainter {
  @override //the paint fun

  int barWidth = 30;
  int rightWidth = 40;
  int leftWidth = 5;

  Size _canvasSize = Size.zero;
  var pointsMap = Map<int, double>();
  double pointHeight = 0;
   
  double paint(Canvas canvas, Size size) {
    var paint = Paint()
    ..color = Colors.teal
    ..strokeWidth = 5
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

    _canvasSize = size; 

    //here we define all 12 positions of the points.
    double horizontalMiddleSpace = (size.height-bottomWidth-topWidth)/7;
    pointHeight = (size.height-horizontalMiddleSpace-topWidth-bottomWidth) / 2;
    double pointWidth = (size.width - leftWidth - rightWidth - barWidth) / 12;




    for (int i=12; i >=1; i--){
      double value;
      int key = i;
      if (i == 12){
        value = leftWidth! + pointWidth!;

      } else if (i == 6){
        value = pointsMap[7]! + barWidth! + pointWidth;
      } else{
        value = pointsMap[i + 1]! + pointWidth!;
      }
      pointsMap[key] = value;      
    }

// drawing the points
    pointsMap.forEach((key, value){
      var path = Path();
      path.moveTo(value-pointWidth/2, size.height-bottomWidth);
      path.relativeLineTo(pointWidth/2, -pointHeight);
      path.relativeLineTo(pointWidth/2, pointHeight);
      path.close();


      path.moveTo(value-pointWidth/2, topWidth);
      path.relativeLineTo(pointWidth/2, pointHeight);
      path.relativeLineTo(pointWidth/2, -pointHeight);
      path.close();

 

      canvas.drawPath(path, paint);
    });
  return pointWidth;

  
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    
    return false;
  }
  double get PointWidth => (_canvasSize.width - leftWidth - rightWidth - barWidth) / 12;
  double get sizeHeight => _canvasSize.height;
  Map get PointsMap => pointsMap;
  double get PointHeight => pointHeight;
}


// We create one object of the class stonesPainter and the positions of all the stones are saved in there. 
class StonesPainter extends CustomPainter{
  final Color customColor;
  final List<int> StonesList;

  StonesPainter(this.customColor, this.StonesList);


  //The positions are defined like so:
  //13 14 15 16 17 18 || 19 20 21 22 23 24
  //\/ \/ \/ \/ \/ \/ || \/ \/ \/ \/ \/ \/
  //                  ||
  ///\ /\ /\ /\ /\ /\ || /\ /\ /\ /\ /\ /\
  //12 11 10 09 08 07 || 06 05 04 03 02 01

  // White starts with 2 at 24.
  // Every color has 15 stones.
  // defining the starting positions of the stones first for white and then for black.

  //Startposition for white
  

  @override
   void paint(Canvas canvas, Size size){
    double strokeWidth = 5;
     var paint = Paint()
     ..color = customColor
     ..strokeWidth = strokeWidth
     ..style = PaintingStyle.stroke
     ..strokeCap = StrokeCap.round;
    double radius = (myBackGroundPainter.PointWidth)/2;
    List CurrentBlackStones = <int>[];

    for (int i = 0; i < StonesList.length; i++){
  
      int stone = StonesList[i];
      double x = 0;
      CurrentBlackStones.add(stone);
      if (stone > 12){

        x = myBackGroundPainter.PointsMap[25-stone];
      } else {
        x = myBackGroundPainter.PointsMap[stone];
      }
      int count = 0;
      double yBase = 0;
      double y = 0;
      double overlap = 0.0;
      double overlapPercentage = 0;
      int totalcount = 0;

      // count the total amount of stones that are on the current stones position:
      for (int i = 0; i < StonesList.length; i++){
        if (StonesList[i] == stone){
          totalcount++;
        }
      }

      // count the current stones on the board
      for (int i = 0; i < CurrentBlackStones.length; i++){
        if (CurrentBlackStones[i] == stone){
          count = count+1;
        } 
      }

      //variable overlap depending on the pointheight
      if (totalcount*2*radius > myBackGroundPainter.PointHeight){
        double difference = 2*totalcount*radius - myBackGroundPainter.PointHeight;
        overlap = difference/(totalcount-1);
        overlapPercentage = overlap/(2*radius);
      }
      if (count == 1){
        overlapPercentage = 0;
        overlap = 0; 
      }

      if (stone > 12){
        y = (topWidth+2*radius*count)-radius-(count-1)*overlap;
      } else{
        yBase = myBackGroundPainter.sizeHeight-bottomWidth+radius;
        y = (yBase-2*radius*count)+(count-1)*overlap;
      }

      var center = Offset(x,y);
      canvas.drawCircle(center, radius, paint);

    }

  }
     @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    
    return false;

 }
}

class dicePainter extends CustomPainter{
   @override
   void paint(Canvas canvas, Size size){
    double strokeWidth = 5;
     var paint = Paint()
     ..color = Colors.purple
     ..strokeWidth = strokeWidth
     ..style = PaintingStyle.stroke
     ..strokeCap = StrokeCap.round;

    double widthDice = 50;


    double yDice = (size.height)/2;
    double xDice1 = (size.width/4);
    double xDice2 = xDice1+widthDice+15;


    var dice1 = Rect.fromCenter(
      center: Offset(xDice1, yDice),
      width: widthDice,
      height: widthDice);
  
    canvas.drawRect(dice1, paint);    
    
}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate){
    return false;
  }
}


