PShape ship, flatEarth, shipSquare, shipSphere;

int c, cameraX, cameraY, cameraZ, speedZ, textCounter, shipY, speedY, speedX, planetCounter;
float textYOffset, shipAngle, shipX, shipZ, shipRotation;
boolean spaceScene, thirdPerson;
PImage img;
final float[] radii = {0.25, 0.3, 0.35, 0.5, 0.6, 0.65};
final float[] orbitSpeed = {1, 0.9, 0.8, 0.7, 0.6, 0.5};
final float[] startingAngle = {random(1), random(1), random(1), random(1), random(1), random(1)};
final int[] planetSizes = {10, 15, 18, 30, 25, 8};

final int COLOR_MAX = 255, WORDS_PER_LINE = 5, MAX_TEXT_SIZE = 40, MIN_TEXT_SIZE = 0;
final char DELIMITER = '\n';
final float TEXT_SPEED = 0.6;
final String STORY_TEXT = "A little ago, in a galaxy far, far away..." + DELIMITER +
"It is a period of civil war. Rebel spaceships" + DELIMITER +
"striking from a hidden base, have won their first victory" + DELIMITER +
"against the evil Galactic Empire. During the battle," + DELIMITER +
"rebel spies managed to steal secret plans to the Empire\'s" + DELIMITER +
"ultimate weapon, the DEATH STAR, an armored space station" + DELIMITER +
"with enough power to destroy an entire planet. Pursued by" + DELIMITER +
"the Empire\'s sinister agents, Princess Leia races home" + DELIMITER +
"aboard her starship, custodian of the stolen plans that" + DELIMITER +
"can save her people and restore freedom to the galaxy...";


void setup(){
  size(1200, 800, P3D);
  surface.setResizable(false);
  stroke(0);
  c = 0;
  initShipPosition();
  //speedZ = 10;
  textYOffset = height-150;
  fill(250, 250, 0);
  textAlign(CENTER, CENTER);
  textSize(MAX_TEXT_SIZE + MIN_TEXT_SIZE);
  textCounter = 0;
  spaceScene = false;
  img = loadImage("space_image.jpg");
  img.resize(width, height);
  sphereDetail(20);
  thirdPerson = false;
}

void initShipPosition(){
  shipX = 0;
  shipY = -50;
  shipZ = 100;
  shipAngle = 0;
}

void keyPressed(){
  if (!spaceScene && key == 'f') {
    changeScene();
  } else if (key == 'w') speedZ = -2;
  else if (key == 's') speedZ = 2;
  else if (key == 'a') speedX = -2;
  else if (key == 'd') speedX = 2;
  else if (key == 'z') speedY = -2;
  else if (key == 'c') speedY = 2;
  else if (key == 'q') shipRotation = 1;
  else if (key == 'e') shipRotation = -1;
  else if (key == 'v') {
    if (thirdPerson) camera();
    thirdPerson = !thirdPerson;
  } else if (key == 'r') initShipPosition();
}

void changeScene(){
  fill(255);
  generateShip();
  setControlsTextStyle();
  spaceScene = true;
}

void keyReleased(){
  if (key == 'w' || key == 's') speedZ = 0;
  else if (key == 'a' || key == 'd') speedX = 0;
  else if (key == 'z' || key == 'c') speedY = 0;
  else if (key == 'q' || key == 'e') shipRotation = 0;
}

void setBackground(){
  background(0);
}

void setPlanetsBackground(){  
  background(img);
}

void globalCoords(){
  translate(width/2, height/2, 0);  
  //rotateX(radians(-30));
}

void starCoords(){
  pushMatrix();  
  rotateZ(radians(-15));
  rotateY(radians(++c));
  sphere(80);
  popMatrix();
}

void planetCoords(float radius, float orbitSpeed, float startingOrbit, int planetSize){
  pushMatrix();
  rotateY(radians(c*orbitSpeed + startingOrbit*360));
  translate(width*radius, 0, 0);
  sphere(planetSize);
  if (planetSize == 18 || planetSize == 25) satelliteCoords(planetSize + 10, 1, 0, 5);
  popMatrix();
}

void satelliteCoords(float radius, float orbitSpeed, float startingOrbit, int satelliteSize){
  pushMatrix();  
  rotateY(radians(c*orbitSpeed + startingOrbit*360));
  translate(radius, 0, 0);
  sphere(satelliteSize);
  popMatrix();
}

void setText(){
  pushMatrix();
  translate(width/2, height/2);
  rotateX(PI/4);
  text(STORY_TEXT, 0, textYOffset);
  textYOffset -= TEXT_SPEED;
  textCounter++;
  popMatrix();
  if (textCounter > 1100) {
    textSize(14);
    fill(255);
    text("Press F to skip", width - 60, height - 30);
    fill(250, 250, 0);
    textSize(MAX_TEXT_SIZE + MIN_TEXT_SIZE);
  }
  if (textCounter == 2000) {
    changeScene();
  }
}

void generateShip(){
  ship = createShape(GROUP);
  shipSquare = createShape(BOX, 30);
  shipSquare.translate(0, 15);
  shipSphere = createShape(SPHERE, 10);
  ship.addChild(shipSquare);
  ship.addChild(shipSphere);
  ship.translate(0, 0, 0);
}

void shipCoords(){
  pushMatrix();
  shipAngle += shipRotation;
  shipX = shipX + speedX * cos(radians(shipAngle)) + speedZ * sin(radians(shipAngle));
  shipZ = shipZ - speedX * sin(radians(shipAngle)) + speedZ * cos(radians(shipAngle));
  translate(shipX, shipY += speedY, shipZ);
  rotateY(radians(shipAngle));
  shape(ship);
  if (thirdPerson) setControlsTextAlt();
  popMatrix();
}

void setShipCamera(){
  camera(width/2 + shipX + 200 * sin(radians(shipAngle)), height/2 + shipY - 100, shipZ + 200 * cos(radians(shipAngle)), width/2 + shipX, height/2 + shipY, shipZ, 0, 1, 0);
}

void setControlsText(){
  textSize(14);
  text("Press W, A, S, D, to control the ship", -width/2 + 10, -height/2 + 20);
  text("Press Q to rotate left and E to rotate right", -width/2 + 10, -height/2 + 40);
  text("Press Z to ascend and C to descend", -width/2 + 10, -height/2 + 60);
  text("Press V to change the view", -width/2 + 10, -height/2 + 80);
  text("Press R to reset the ship position", -width/2 + 10, -height/2 + 100);
}

void setControlsTextAlt(){
  textSize(6);
  pushMatrix();
  rotateX(PI/8);
  text("Press W, A, S, D, to control the ship", -180, -115);
  text("Press Q to rotate left and E to rotate right", -180, -105);
  text("Press Z to ascend and C to descend", -180, -95);
  text("Press V to change the view", -180, -85);
  text("Press R to reset the ship position", -180, -75);
  popMatrix();
}

void setControlsTextStyle(){
  textSize(14);
  fill(255);
  textAlign(LEFT, LEFT);
}

void draw(){
  if (!spaceScene){
    setBackground();  
    setText();
  } else {
    setPlanetsBackground();
    globalCoords();
    starCoords();
    shipCoords();    
    for (int i = 0; i < 6; i++) planetCoords(radii[i], orbitSpeed[i], startingAngle[i], planetSizes[i]);
    //setControlsText();
    if (thirdPerson) setShipCamera();
    else setControlsText();
  }
  

}
