ArrayList<Ball> balls;

class Ball {
  float x, y, vx, vy, d;
  float ay = 1, ax = 1;
  color c;
  Ball(color c, float x, float y, float vx, float vy, float d) {
    this.c = c;  
    this.x = x; 
    this.y = y; 
    this.vx = vx; 
    this.vy = vy; 
    this.d = d;
  }
  void move(int w, int h) {
    float angle = atan2(   mouseY - width/2 , mouseX - height/2);
    ax = cos(angle);
    ay = sin(angle);

    x += vx; //x = x + vx is the same
    y += vy;
    vy += ay;
    vx += ax;
    vy *= 0.99; //drag (reduction of speed)
    vx *= 0.99; 
    if ( (x>width && vx > 0) || (x < 0 && vx < 0)) { // if past left or right side of screen
      vx = -vx;   //flip velocity (so if going right then go left)
    }
    if ( (y>height && vy > 0) || (y < 0 && vy < 0)) {
      vy = -vy;
    }
  }
  void collide(Ball other) {
    float spring = 1;
    float energyLoss = .3;
    if (other == this) return;
    float dx = other.x - x;
    float dy = other.y - y;
    float distance = sqrt(dx*dx + dy*dy);
    float minDist = other.d/2 + d/2;
    if (distance < minDist) {
      float angle = atan2(dy, dx);
      float targetX = x + cos(angle) * minDist;
      float targetY = y + sin(angle) * minDist;
      float ax = (targetX - other.x) * spring;
      float ay = (targetY - other.y) * spring;
      vx -= ax * energyLoss;
      vy -= ay * energyLoss;
      other.vx += ax * energyLoss;
      other.vy += ay * energyLoss;
    }
  }

  void display() {
    fill(c);  
    noStroke(); //no border
    ellipse(x, y, d, d);  //by default x,y is corner, e.g. ellipseMode(CENTER);
  }
}
void setup() {
  size(500, 500);
  balls = new ArrayList<Ball>();
  balls.add(new Ball(color(255, 0, 0), 130, 300, 1.3, -2, 25));
}
void draw() {
  background(200); //grey
  for ( Ball b : balls) {  //read "For each Ball b in balls"
    b.display(); 
    b.move(width, height);
    for ( Ball o : balls) {
      if ( b != o ) b.collide(o); //note you don't need {} if it's one line
    }
  }
}
void mousePressed() {
  color c = color(random(0, 255), random(0, 255), random(0, 255), random(0, 255));
  balls.add(new Ball(c, mouseX, mouseY, random(-5, 5), random(-5, 5), random(20, 70)));
}
