import processing.sound.*;

SoundFile jingleBells;
boolean showHomePage = true;
PFont font;
int buttonX, buttonY, buttonWidth, buttonHeight;
int backButtonX, backButtonY, backButtonWidth, backButtonHeight;
boolean playSound = false;

int[] colors = {color(255, 0, 0), color(0, 255, 0), color(0, 0, 255), color(255, 255, 0), color(255, 0, 255)};
PVector[] positions;
float[] swingAngles; // Angles for swinging motion
float swingAmplitude = PI / 8; // Maximum swing amplitude
float swingSpeed = 0.05; // Speed of swinging motion
int ballSize = 80;
int colorChangeInterval = 500; // milliseconds
int lastColorChange = 0;
int[] currentColorIndex = {0, 1, 2, 3, 4}; // Initial colors for each ball

void setup() {
  size(600, 400);
  
  // Load sound file
  jingleBells = new SoundFile(this, "jinglebells.mp3"); // Ensure the file is in the 'data' folder
  
  // Text setup
  font = createFont("Arial-Bold", 48);
  textFont(font);
  
  // Button setup
  buttonX = width / 2 - 50;
  buttonY = height / 2 + 100;
  buttonWidth = 100;
  buttonHeight = 40;

  // Back button setup
  backButtonX = 20;
  backButtonY = 20;
  backButtonWidth = 80;
  backButtonHeight = 30;
  
  // Initialize ball positions and swing angles
  positions = new PVector[] {
    new PVector(150, 150),
    new PVector(250, 100),
    new PVector(350, 100),
    new PVector(450, 150),
    new PVector(300, 250)
  };
  swingAngles = new float[positions.length];
  for (int i = 0; i < swingAngles.length; i++) {
    swingAngles[i] = random(TWO_PI);
  }
}

void draw() {
  if (showHomePage) {
    drawHomePage();
  } else {
    drawChristmasPage();
  }
}

void drawHomePage() {
  // Draw gradient background
  for (int i = 0; i < height; i++) {
    float inter = map(i, 0, height, 0, 1);
    int c = lerpColor(color(255, 0, 0), color(0, 255, 0), inter);
    stroke(c);
    line(0, i, width, i);
  }
  
  // Display text
  fill(255);
  textAlign(CENTER);
  text("Paige's Piano Christmas Carols", width / 2, height / 2 - 100);
  
  // Display play button
  fill(0, 102, 204);
  rect(buttonX, buttonY, buttonWidth, buttonHeight, 10);
  fill(255);
  textSize(16);
  text("Play", width / 2, buttonY + buttonHeight / 2 + 5);
}

void drawChristmasPage() {
  background(200);

  // Draw flashing and swinging balls
  drawBaubles();
  updateBaubleColors();
  
  // Play sound if it hasn't been started yet
  if (!playSound) {
    jingleBells.play();
    playSound = true;
  }
  
  // Draw back button
  fill(200, 0, 0);
  rect(backButtonX, backButtonY, backButtonWidth, backButtonHeight, 5);
  fill(255);
  textSize(14);
  textAlign(CENTER, CENTER);
  text("Back", backButtonX + backButtonWidth / 2, backButtonY + backButtonHeight / 2);
}

void drawBaubles() {
  for (int i = 0; i < positions.length; i++) {
    PVector pos = positions[i];
    
    // Calculate swinging offset
    float swingOffsetX = sin(swingAngles[i]) * swingAmplitude * ballSize;
    swingAngles[i] += swingSpeed;
    
    // Draw string
    stroke(255, 0, 0);
    line(pos.x, 0, pos.x + swingOffsetX, pos.y - ballSize / 2);
    
    // Draw bauble cap
    fill(255, 215, 0); // Gold color
    rect(pos.x + swingOffsetX - 10, pos.y - ballSize / 2 - 10, 20, 10);
    
    // Draw bauble body with gradient and current color
    noStroke();
    for (int j = 0; j < ballSize / 2; j++) {
      int gradientColor = lerpColor(color(255), colors[currentColorIndex[i]], j / (float)(ballSize / 2));
      fill(gradientColor);
      ellipse(pos.x + swingOffsetX, pos.y, ballSize - j, ballSize - j);
    }
    
    // Draw decorative stars
    drawDecorativeStars(pos.x + swingOffsetX, pos.y);
  }
}

void updateBaubleColors() {
  if (millis() - lastColorChange > colorChangeInterval) {
    lastColorChange = millis();
    for (int i = 0; i < currentColorIndex.length; i++) {
      currentColorIndex[i] = (currentColorIndex[i] + 1) % colors.length; // Cycle through colors
    }
  }
}

void drawDecorativeStars(float x, float y) {
  float sparkleSize = ballSize / 10;
  fill(255, 255, 255, 200); // White with some transparency
  noStroke();
  
  // Draw star-like sparkles around the bauble
  ellipse(x - sparkleSize, y - sparkleSize, sparkleSize, sparkleSize);
  ellipse(x + sparkleSize, y + sparkleSize, sparkleSize, sparkleSize);
  ellipse(x - sparkleSize / 2, y + sparkleSize, sparkleSize / 2, sparkleSize / 2);
  ellipse(x + sparkleSize, y - sparkleSize / 2, sparkleSize / 2, sparkleSize / 2);
}

void mousePressed() {
  // Check if play button is clicked on home page
  if (showHomePage && mouseX > buttonX && mouseX < buttonX + buttonWidth && mouseY > buttonY && mouseY < buttonY + buttonHeight) {
    showHomePage = false;
    playSound = false; // Reset the sound play flag for Christmas page
  }
  
  // Check if back button is clicked on Christmas page
  if (!showHomePage && mouseX > backButtonX && mouseX < backButtonX + backButtonWidth && mouseY > backButtonY && mouseY < backButtonY + backButtonHeight) {
    showHomePage = true;
    jingleBells.stop(); // Stop the music when going back to home page
  }
}
