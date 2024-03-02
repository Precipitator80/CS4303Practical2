public class Robotron extends Scene {
    LevelManager levelManager;
    
    AStarTester aStarTester;
    
    public Robotron() {
        super(color(255), color(128));
        
        // 16 by 9 times 2
        levelManager = new LevelManager(32, 18);
        levelManager.spawnLevel();
    }
    
    void update() {
        super.update();
        if (levelManager.player.alive() && BUTTON_MANAGER.mouseDown && levelManager.player.currentWeapon.automatic) {
            levelManager.player.currentWeapon.tryToFire(mouseX, mouseY);
        }
    }
    
    void render() {
        // Background
        background(0);
        
        // Render cells.
        levelManager.render();
        
        // Foreground
        super.render();
        
        if (DEBUG_MODE) {
            aStarTester.render();
        }
        
        // Show a message on the game's state to the player.
        fill(255);
        textSize(height / 25);
        textAlign(CENTER);
        text("Welcome to Robotron: 4303!\nPress enter to start the game.", width / 2, height / 2);
    }
    
    void mousePressed() {
        super.mousePressed();
        if (levelManager.player.alive()) {
            levelManager.player.currentWeapon.tryToFire(mouseX, mouseY);
        }
    }
    
    void mouseReleased() {
        super.mouseReleased();
        if (DEBUG_MODE) {
            aStarTester.mouseReleased();
        }
    }
    
    void keyPressed() {
        levelManager.player.checkMovementKeys(true);
    }
    
    void keyReleased() {
        levelManager.player.checkMovementKeys(false);
        if (key == ' ') {
            levelManager.spawnLevel();
        }
        if (DEBUG_MODE) {
            aStarTester.keyReleased();
        }
    }
}