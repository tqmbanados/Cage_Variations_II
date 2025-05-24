static class Math {
  //static class with some math functions 
  
  static boolean checkRectCollision(float[] r1, float[] r2) {
    //vectors defined as float array as follows {x, y, width, height}
    // code adapted from https://www.jeffreythompson.org/collision-detection/rect-rect.php
    if (r1[0] + r1[2] >= r2[0]         &&    
        r1[0]         <= r2[0] + r2[2] &&   
        r1[1] + r1[3] >= r2[1]         &&    
        r1[1]         <= r2[1] + r2[3])   {    
          return true;
    }
    return false;
  }
  
  static PVector polar2cartesian(float r, float a) {
    float x = r * cos(a);
    float y = r * sin(a);
    return new PVector(x, y);
  }
  
  static float[] cartesian2polar(PVector pos) {
    float r = pos.mag();
    float a = atan2(pos.y, pos.x);
    float[] res = {r, a};
    return res;
  }
}


class Line {
  // Line definition using two points
  PVector p1;
  PVector p2;
  float coefA;
  float coefB;
  
  Line (PVector p1, PVector p2) {
    this.p1 = p1;
    this.p2 = p2;
    this.coefA = (p1.y - p2.y) / (p1.x - p2.x);
    this.coefB = p1.y - (coefA * p1.x);
    //println(p1, p2, ": y = ", coefA, "* x  +  ", coefB);
  }

  float getY (float X) {
    return coefA * X + coefB;
  }
  
  float distanceToPoint(PVector P) {
    float num = abs( (P.x * (p2.y - p1.y)) - (P.y * (p2.x - p1.x)) + (p2.x * p1.y) - (p2.y * p1.x) );
    float den = sqrt(pow(p2.x - p1.x, 2.) + pow(p2.y - p1.y, 2.));
    return num / den;
  
  }
  
  float magnitude() {
    return PVector.sub(p1, p2).mag();
  }
  
  PVector closestPoint(PVector P) {
    //y = ax + b
    //0 = ax + b - y
    float a = coefA;
    float b = -1.;
    float c = coefB;
    float den = pow(a, 2.) + pow(b, 2.);
    float X = (b * ( (b * P.x) - (a * P.y))  -  (a * c)) / den;
    float Y = (a * ((-b * P.x) + (a * P.y))  -  (b * c)) / den;
    return new PVector(X, Y);
    
  }

  void display() {
    //stroke and colour data should be defined before calling this method
    line(p1.x, p1.y, p2.x, p2.y);
  }
 
}

class Point {
  // A Point, that draws to nearby lines
  PVector p;
  color c;
  Line[] distanceLines;
  int displayingLines = 0;
  String name;
  
  Point (PVector p, color c, String name) {
    this.p = p;
    this.c = c;
    this.distanceLines = new Line[numLines];
    this.name = name;
  }
  
  void createLines(Line[] ls) {
    for (int i=0; i<numLines; i++) {
      PVector targetPoint = ls[i].closestPoint(p);
      Line newLine = new Line(p, targetPoint);
      this.distanceLines[i] = newLine;
    }
  }

  void display() {
    strokeWeight(16);
    stroke(c);
    point(p.x, p.y);
    if (displayingLines == 1) {
      strokeWeight(2);
      for (Line l: this.distanceLines) {
        l.display();
      }
    }
  }
}

class Label {
 // used to print non overlapping text on screen
 PVector startPos;
 PVector currentPos;
 String text;

  Label (PVector pos, String text) {
    this.startPos = pos;
    this.currentPos = pos;
    this.text = text;
  
  }
  
  float[] getBounds() {
    //returns bounding box of label with current font
    float w = textWidth(text) + 1;
    float h = textAscent() + textDescent() + 1;
    float[] bounds = {currentPos.x, currentPos.y, w, h};
    return bounds;
  }
  
  boolean checkBounds(float[][] allBounds, float[] thisBounds) {
    // test if text has collision, return 1                 
    for (float[] bound: allBounds) {
      if (Math.checkRectCollision(bound, thisBounds)) {return true;}
    }
    return false;
  }
  
  boolean checkInside(float[] thisBounds) {
    //returns true if text is inside the screen
    if (thisBounds[0] < 0 || thisBounds[1] < 0 || (thisBounds[0] + thisBounds[2]) > width || (thisBounds[1] + thisBounds[3]) > height) {
      return false;
    }
    else {
      return true;
    }
  }
  

  
}
  
  
  
