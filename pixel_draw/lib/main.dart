import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          
          title: Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset("assets/icon_512.png", width: 50, height:50), // draw image icon in appbar
                Text('Draw', 
                  style: TextStyle(fontWeight: FontWeight.bold)
                ),
              ]
            )
            
          ),
          backgroundColor: Colors.green,
          
        ),
        body: Center(
          //child: Tile('A', HitType.partial),
          child: PaintPage()
        ),
        
      ),
    );
  }
}

/// Page

class PaintPage extends StatefulWidget {
  const PaintPage({super.key});

  @override
  State<PaintPage> createState() => _PaintPageState();
}
class _PaintPageState extends State<PaintPage> {
  //final Game _game = Game();
  var tiles = [];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 3,
        children: [
          
          tileGrid(),
          SizedBox(height: 10.0), // space out tiles and buttons
          ColorButtons(),
          
        ]
      )
    );
  }
}

// small static tracker for whether there is a click or not
class ClickTracker {
  static bool isClicking = false;
}

class tileGrid extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        print("Mouse entered container.");
        print(ClickTracker.isClicking);
      },
      onExit: (event) {
        ClickTracker.isClicking = false;
        print("Mouse left the container.");
        print(ClickTracker.isClicking);
        },
      child: GestureDetector(
        onTapDown: (details) {
          ClickTracker.isClicking = true;
          print("Started clicking.");
          print(ClickTracker.isClicking);
          },
        
        onTapUp: (details) {
          ClickTracker.isClicking = false;
          print("Stopped clicking.");
          print(ClickTracker.isClicking);
        },
        onPanStart: (details) {
          ClickTracker.isClicking = true;
          print("Started panning.");
          print(ClickTracker.isClicking);
        },
        onPanEnd: (details) {
          ClickTracker.isClicking = false;
          print("Stopped panning.");
          print(ClickTracker.isClicking);
        },

        child: Container(
          color: Colors.blue,
          width: double.infinity,
          child: Column(
            spacing: 3,
            children: [
              for (var i in [0,2,5,9,14,20]) 
                Row(
                  
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 3,
                  
                  children: [
                    //for (var j in [1,2])
                    for (var j in [1,2,3,4,5,6])
                      ClickableTile(),
                  ]
                ),
            ]
          )
        )
      )
    );
  }
}

/// Define Paintable Tile

class ClickableTile extends StatefulWidget {
  
  const ClickableTile({super.key});
  static Color brushColor = Colors.black;
  
  // creates the state
  @override
  _ClickableTile createState() => _ClickableTile();
}
class _ClickableTile extends State<ClickableTile> {  

  Color currentColor = Colors.grey;

  void doClick() {
    setState(() {
      paintTile();
    });
    print(ClickTracker.isClicking);
  }
  void paintTile() {
    currentColor = ClickableTile.brushColor;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion( // detect clicks
      onEnter: (details) {
        print("Hovered tile.");
          print(ClickTracker.isClicking);
        if (ClickTracker.isClicking) {
          print("Is clicked — Setting state.");
          doClick();
        }
      },
      child: GestureDetector(
        onTapDown: (details) {
          doClick();
        },
        onPanStart: (details) { 
          doClick();
          ClickTracker.isClicking = true;
          //print("Started panning");
          //print(ClickTracker.isClicking);
        },
        onPanEnd: (details) {
          ClickTracker.isClicking = false;
          //print("Stopped Panning");
          //print(ClickTracker.isClicking);
        },
        // release
        onTapUp: (details) {
          ClickTracker.isClicking = false;
          //print("Untapped");
          //print(ClickTracker.isClicking);
        },
        
        child: Container(
          width: 50,
          height: 50,
          // color: _state ? Colors.blue : Colors.grey, // blue if active; grey if not.
          color: currentColor,
        ),
      ),
    );
  }
} 

/// Buttons to Change Paint Color
class ColorButtons extends StatefulWidget {
  const ColorButtons({super.key});
  @override
  _ColorButtons createState() => _ColorButtons();
}
class _ColorButtons extends State<ColorButtons> {
  
  int selectedIdx = 2;
  
  // List of valid colors
  final _colors = [
    [Colors.black, "Black"],
    [Colors.white, "White"],
    [const Color.fromRGBO(128, 16, 8, 1), "Dark Red"],
    [Colors.red, "Red"],
    [Colors.green, "Green"],
    [Colors.blue, "Blue"],
    [Colors.purple, "Purple"],
    [Colors.brown, "Brown"],
    [Colors.yellow, "Yellow"]
  ];
  Color _getColor(int idx) {
    return _colors[idx][0] as Color;
  }
  String _getColorName(int idx) {
    return _colors[idx][1] as String;
  }

  void onSelect(int idx) {
    if (selectedIdx != idx) { // if not already selected
      selectedIdx = idx; // select
    } else {
      selectedIdx = 0; // represents no option selected
    }
  }
  // structure
  @override
  Widget build(BuildContext context) {
    return Wrap(
      //mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      runSpacing: 10,
      // for each element
      children: List.generate(_colors.length, (index) {
        // if selected
        // if (index != selectedIdx) {
          return GestureDetector(
            onTapDown: (details) {
              // change brush color to clicked button color
              setState(() {
                ClickableTile.brushColor = _getColor(index);
                selectedIdx = index;
              });
            },
            // one button
            child: Container(
              width:100,
              height:50,
              // has border if selected
              decoration: BoxDecoration(
                border: index == selectedIdx ? Border.all(color:Colors.blueGrey, width:3):Border.all(color:Colors.white,width:1),
                color: _getColor(index),
              ),
              child: Center(
                child: Text(
                  _getColorName(index), // text to display
                  style: TextStyle(
                      color:Colors.yellowAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )
                )
              )
            )
          );
      }),
    );
  }
}