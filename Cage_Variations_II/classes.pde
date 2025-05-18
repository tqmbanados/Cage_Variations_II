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
  
  Point (PVector p, color c) {
    this.p = p;
    this.c = c;
    this.distanceLines = new Line[numLines];
  }
  
  void createLines(Line[] ls) {
    for (int i=0; i<numLines; i++) {
      PVector targetPoint = ls[i].closestPoint(p);
      Line newLine = new Line(p, targetPoint);
      this.distanceLines[i] = newLine;
    }
  }

  void display(int displayLines) {
    strokeWeight(16);
    stroke(c);
    point(p.x, p.y);
    if (displayLines == 1) {
      strokeWeight(2);
      for (Line l: this.distanceLines) {
        l.display();
      }
    }
  }
 




}
  
  
  
