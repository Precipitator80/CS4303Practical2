public class Robotron extends Scene {
    LevelManager levelManager;
    
    AStarTester aStarTester;
    
    public Robotron() {
        super(color(255), color(128));
        
        // 16 by 9 times 2
        levelManager = new LevelManager(32, 19);
        levelManager.spawnLevel();
        levelManager.state = LevelState.WELCOME;
    }
    
    void update() {
        super.update();
        levelManager.update();
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
        switch(levelManager.state) {
            case WELCOME : 
                text("Welcome to Robotron: 4303!\nPress enter or space to start the game.", width / 2, height / 2);
                break;
            case POST_LEVEL : 
                text("Wave " + levelManager.wave + " completed!\nPress enter or space to continue.", width / 2, height / 2);
                break;
            case GAME_OVER:
                text("Game over!\nPress enter or space to restart.", width / 2, height / 2);
                break;
        }
        
        // Show the score.
        if (levelManager.state != LevelState.WELCOME) {
            textAlign(LEFT);
            text("Score: " + levelManager.score + "\nWave: " + levelManager.wave, width / 100, height / 25);
        }
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
        
        switch(key) {
            case ' ':
                case ENTER:
                //if (!OptionsMenu.enabled() && !ShopMenu.enabled()) {
                switch(levelManager.state) {
                    case GAME_OVER:
                    case WELCOME:
                    levelManager.resetGame();
                    case POST_LEVEL:
                    //OptionsMenu.entryButton.hide();
                    //ShopMenu.entryButton.hide();
                    levelManager.spawnLevel();
                    break;
            //}
            }
            break;
        }
    }
    
    void keyReleased() {
        levelManager.player.checkMovementKeys(false);
        if (DEBUG_MODE) {
            aStarTester.keyReleased();
        }
    }
}