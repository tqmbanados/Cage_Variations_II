int numLines = 6;
int numPoints = 5;
color[] pointColours = {color(250, 16, 64), color(216, 16, 255), color(255, 216, 32), color(64, 196, 255), color(0, 255, 32)}; //should be at least as long as numPoints
String[] parameterNames = {"Frequency", "Amplitude", "Timbre", "Duration", "Point of Occurrence", "Event Structure"}; //should be at least as long as numLines
Point[] points = new Point[numPoints];
Line[] lines = new Line[numLines];

PVector zero = new PVector(0., 0.);
PVector dimensions;
PVector mouseV = new PVector(0., 0.);

float cornerAvoidance = 0.1; // 
int minMouseDistance = 30;

void setup() {
  size(1024, 512);
  background(0);
  dimensions = new PVector(float(width), float(height));
  createVariationsMap();
}

void draw() {
  background(0);
  stroke(255);
  strokeWeight(2);
  mouseV.x = mouseX;
  mouseV.y = mouseY;
  
  for (Line line: lines) { //<>//
    line.display();
  }
  
  for (Point point: points) {
    float d = point.p.dist(mouseV);
    if (d < minMouseDistance) {
      point.displayingLines = 1;
    }
    else {
      point.displayingLines = 0;
    }
    point.display();
  }

}

void mousePressed() {
   for (Point point: points) {
    if (point.displayingLines == 1) {
      for (int i = 0; i < numLines; i++) {
        println(parameterNames[i] + ": " + point.distanceLines[i].magnitude());
      }
      println();
    }
  }
}

void keyReleased() {
  if (key == ' ') {
    createVariationsMap();    
  }
  else if (key == 's') {
    String filename = "Cage_Variations_II" + year() + month() + day() + "_" + hour() + "-" + "-####.png";
    saveFrame("savedFrames/" + filename);
  }

}

void createVariationsMap() {
  for (int i = 0; i < numLines; i++) {
    Line l = generateLine(dimensions);
    lines[i] = l;
  } 
  
  for (int i = 0; i < numPoints; i++) {
    float x = random(cornerAvoidance, 1. - cornerAvoidance) * dimensions.x;
    float y = random(cornerAvoidance, 1. - cornerAvoidance) * dimensions.y;
    color c = pointColours[i];
    Point p = new Point(new PVector(x, y), c);
    p.createLines(lines);
    points[i] = p;
  } 
}


Line generateLine(PVector d) {
  IntList intList = new IntList(0, 1, 2, 3);
  intList.shuffle();
  PVector p1 = getRandomSidePoint(intList.remove(0), d);
  PVector p2 = getRandomSidePoint(intList.remove(0), d);
  //println(p1, p2);
  return new Line(p1, p2);
}

PVector getRandomSidePoint(int side, PVector d) {
  float x = random(cornerAvoidance, 1. - cornerAvoidance);
  float[][] points = {{0, x * d.y},   {d.x, x * d.y},   {x * d.x, 0},   {x * d.x, d.y}};
  return new PVector(points[side][0], points[side][1]);
}

PVector reframeVector(PVector v1, PVector v2) {
  return new PVector(v1.x * v2.x, v1.y * v2.y);
}
