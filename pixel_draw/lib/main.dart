import 'package:flutter/material.dart';

const double TILE_WIDTH  = 50.0;
const double TILE_HEIGHT = 50.0;
const double TILE_SPACING_HEIGHT = 0.0;
const double TILE_SPACING_WIDTH = 0.0;
const int TILE_COUNT_Y = 10;
const int TILE_COUNT_X = 10;
void main() {
  CData();
  GridData();
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
          
          TileGrid(),
          SizedBox(height: 10.0), // space out tiles and buttons
          ColorButtons(),
          
        ]
      )
    );
  }
}

// small static tracker for user states of click and brush color
class CData {
  //static bool isClicking = false;
  static Color brushColor = Colors.black;
  static bool tilesInitalized = false;
}

class GridData {
  static List<List<Color>> _tileColors = [];
  static int lastClickedCol = -1;
  static int lastClickedRow = -1;
  GridData() {
    if (!CData.tilesInitalized) {
      createBoard();
    }
  }
  static void resetBoard() {
    if (_tileColors.isEmpty) return;
    if (_tileColors[0].isEmpty) return;
    for (int row = 0; row< _tileColors.length; row++) {
      for (int col = 0; col < _tileColors[0].length; col++) {
        setColor(row, col, Colors.grey);
      }
    }
  }
  static void createBoard() {
    _tileColors = []; // clear first
    // create rows
    for (int row = 0; row<TILE_COUNT_Y; row++) {
      _tileColors.add([]);
      // populate row
      for (int col = 0; col<TILE_COUNT_X; col++) {
        _tileColors[row].add(Colors.grey);
      }
    }  
  }
  static void setColor(int row, int col, Color color) {
    if (isValid(row, col)) {
      _tileColors[row][col] = color;
    }
  }
  static bool isValid(int row, int col) {
    if (row < 0 || row > _tileColors.length-1 ||
        col < 0 || col > _tileColors.length-1) 
      {return false;}
    return true;
  }
  static bool isColor(int row, int col, Color color) {
    if (isValid(row,col)) {
      return _tileColors[row][col] == color ? true : false;
    }
    return false;
  }
  static List<List<Color>> getBoard() {
    return _tileColors;
  }
}

class TileGrid extends StatefulWidget {
  const TileGrid({super.key});
  
  @override
  State<TileGrid> createState() => _TileGrid();
}

class _TileGrid extends State<TileGrid> {
  
  // access info with [row][col]
  void updateTile(int row, int col) {
    setState((){
      GridData.setColor(row, col, CData.brushColor);
      print("Updated tile color for [$row, $col]");
    });
  }
  /* Handle a mouse interaction to change tile color */
  void handleInteraction(Offset relPos) {
    int col = getSquare(relPos.dx, false);
    int row = getSquare(relPos.dy, true);
    print("Tile: [$row, $col]");
    // if this is the same square as before, don't click.
    if (!GridData.isColor(row,col,CData.brushColor)) {
      if (col > -1 && row > -1 && col < TILE_COUNT_X && row < TILE_COUNT_Y) {
        updateTile(row,col);
      }
      else {
        print("Invalid position.");
      }
    }

  }
  /*
  GET SQUARE
  relPos - an X or Y coordinate relative to the container's top left (0) 
  isVertical - whether to use TILE_HEIGHT and TILE_SPACING_HEIGHT (T) or TILE_WIDTH and TILE_SPACING_WIDTH (F).
  Returns -1 if click is in padding
  */
  int getSquare(double relPos, bool isVertical) {
    double len = isVertical ? TILE_HEIGHT : TILE_WIDTH;
    double gap = isVertical ? TILE_SPACING_HEIGHT : TILE_SPACING_WIDTH;
    
    int squareNum = (relPos/(len + gap)).floor();
    double extraBlockPixels = squareNum*(len+gap) + len;
    // we added as many block+padding units as possible, then added one more block; 
    //if it's still less than the given position, then the position is between blocks (out of bounds)
    if (extraBlockPixels < relPos) {
      return -1; // invalid
    }
    return squareNum;
  }

  @override
  Widget build(BuildContext context) {
    return //MouseRegion(
      // onEnter: (event) {
      //   print("Mouse entered container.");
      //   print(ClickTracker.isClicking);
      // },
      // onExit: (event) {
      //   ClickTracker.isClicking = false;
      //   print("Mouse left the container.");
      //   print(ClickTracker.isClicking);
      //   },
      /*child:*/ GestureDetector(
        // TODO: edit to identify locations of each interaction
        onTapDown: (details) {
          //CData.isClicking = true;
          print("Started clicking at local [${details.localPosition})], global [${details.globalPosition}]");
          //print(CData.isClicking);
          handleInteraction(details.localPosition);
          },
        
        onTapUp: (details) {
          //CData.isClicking = false;
          print("Stopped clicking.");
          //print(CData.isClicking);
        },
        onPanStart: (details) {
          
          //CData.isClicking = true;
          print("Started panning.");
          //print(CData.isClicking);
          handleInteraction(details.localPosition);
        },
        onPanEnd: (details) {
          //CData.isClicking = false;
          print("Stopped panning.");
          //print(CData.isClicking);
        },
        onPanUpdate: (details) {
          //print("Pan: local [${details.localPosition}], global [${details.globalPosition}]");
          handleInteraction(details.localPosition);
        },
        
        child: IntrinsicWidth(child:Container(
          //color: Colors.blue, // color for testing

          child: Column(
            spacing: TILE_SPACING_HEIGHT,
            
            children: [
              for (List<Color> row in GridData._tileColors) 
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: TILE_SPACING_WIDTH,
                  
                  children: [
                    //for (var j in [1,2])
                    for (Color colorInfo in row)
                      ClickableTile(colorInfo),
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
  
  const ClickableTile(this.currentColor, {super.key});
  final Color currentColor; // the tile's color
  // creates the state
  @override
  State<ClickableTile> createState() => _ClickableTile();
}
class _ClickableTile extends State<ClickableTile> {  
  // void doClick() {
  //   setState(() {
  //     paintTile();
  //   });
  //   print(UserStates.isClicking);
  // }
  // void paintTile() {
  //   currentColor = UserStates.brushColor;
  // }

  @override
  Widget build(BuildContext context) {
    return MouseRegion( // detect clicks
      // onEnter: (details) {
      //   print("Hovered tile.");
      //     print(ClickTracker.isClicking);
      //   if (ClickTracker.isClicking) {
      //     print("Is clicked — Setting state.");
      //     doClick();
      //   }
      // },
      child: GestureDetector(
        // onTapDown: (details) {
        //   doClick();
        // },
        // onPanStart: (details) { 
        //   doClick();
        //   UserStates.isClicking = true;
        //   print("Started panning");
        //   print(UserStates.isClicking);
        // },
        // onPanEnd: (details) {
        //   UserStates.isClicking = false;
        //   print("Stopped Panning");
        //   print(UserStates.isClicking);
        // },
        // // release
        // onTapUp: (details) {
        //   UserStates.isClicking = false;
        //   //print("Untapped");
        //   //print(ClickTracker.isClicking);
        // },
        
        child: Container(
          width: TILE_WIDTH,
          height: TILE_HEIGHT,
          // color: _state ? Colors.blue : Colors.grey, // blue if active; grey if not.
          color: widget.currentColor,
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
                CData.brushColor = _getColor(index);
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
                      color:Colors.orangeAccent,
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