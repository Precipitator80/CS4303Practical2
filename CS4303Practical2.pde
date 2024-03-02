// IDEAS FOR VARIATION:
// HAVE UPGRADE SYSTEM BETWEEN WAVES - Put it as a button in the corner rather than forcing it open.
// START SETTINGS
import processing.sound.*;
import java.util.LinkedList;
import java.util.concurrent.LinkedTransferQueue;

//// Final values

//// Early initialisation.
// Utility class with additional methods.
final Utility Utility = new Utility();

final boolean DEBUG_MODE = false;

//// Late initialisation.
Audio Audio;
Graphics Graphics;
Scene currentScene;

// Update manager
double previous;
double lag;
double ms_per_update;

void setup() {
    // Set the screen size.
    // 1:1
    //size(720, 720);
    
    // 16:9
    //size(1280, 720);
    
    // 21:9
    //size(1680, 720);
    
    fullScreen();
    
    // Initialise the update timer.    
    previous = millis();
    lag = 0.0;
    ms_per_update = 1000.0 / frameRate;
    
    // Load all assets.
    Audio = new Audio(this);
    Graphics = new Graphics();
    
    // Load the first scene.
    currentScene = new Robotron();
    noSmooth(); // Decide whether or not to use anti-aliasing.
}

void draw() {
    double current = millis();
    double elapsed = current - previous;
    previous = current;
    lag += elapsed;
    while(lag >= ms_per_update) {
        currentScene.update();
        lag -= ms_per_update;
    }
    currentScene.render();
}

void mousePressed() {
    currentScene.mousePressed();
}

void mouseReleased() {
    currentScene.mouseReleased();
}

void keyPressed() {
    currentScene.keyPressed();
}

void keyReleased() {
    currentScene.keyReleased();
}

LinkedTransferQueue<GameObject> gameObjects() {
    return currentScene.OBJECT_MANAGER.gameObjects;
}

LinkedTransferQueue<Button> buttons() {
    return currentScene.BUTTON_MANAGER.buttons;
}