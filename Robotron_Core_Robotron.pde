public class Robotron extends Scene {
    OptionsMenu OptionsMenu;
    LevelManager levelManager;
    ShopMenu ShopMenu;
    
    AStarTester aStarTester;
    
    public Robotron() {
        super(color(255), color(128));
        
        // Initialise the options menu.
        OptionsMenu = new OptionsMenu();
        OptionsMenu.entryButton.show();
        
        // 16 by 9 times 2
        levelManager = new LevelManager(32, 19);
        levelManager.spawnLevel();
        levelManager.state = LevelState.WELCOME;
        
        // Initialise the shop.
        ShopMenu = new ShopMenu();
    }
    
    void update() {
        super.update();
        levelManager.update();
        Player player = levelManager.player;
        if (player.alive() && !player.frozen && BUTTON_MANAGER.mouseDown && mouseButton == LEFT) {
            player.currentWeapon.tryToFire(mouseX, mouseY);
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
        if (!OptionsMenu.enabled && !ShopMenu.enabled) {
            switch(levelManager.state) {
                case WELCOME : 
                    text("Welcome to Robotron: 4303!\nPress enter or space to start the game.", width / 2, height / 2);
                    break;
                case POST_LEVEL : 
                    text("Wave " + levelManager.wave + " completed!\nPress enter or space to continue.", width / 2, height / 2);
                    break;
                case GAME_OVER:
                    text("Game over!\nPress enter or space to restart.", width / 2, height / 2);
                    OptionsMenu.entryButton.show();
                    break;
            }
        }
        
        // Show the score.
        if (levelManager.state != LevelState.WELCOME) {
            textAlign(LEFT);
            text("Score: " + levelManager.score + "\nWave: " + levelManager.wave + "\nLives: " + levelManager.player.livesLeft(), width / 100, height / 25);
        }
    }
    
    void mousePressed() {
        super.mousePressed();
        if (levelManager.player.alive() && !levelManager.player.frozen && mouseButton == RIGHT) {
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
        levelManager.player.checkKeys(true);
        
        switch(key) {
            case ' ':
                case ENTER:
                if (!OptionsMenu.enabled && !ShopMenu.enabled) {
                    switch(levelManager.state) {
                        case GAME_OVER:
                        case WELCOME:
                        levelManager.resetGame();
                        case POST_LEVEL:
                        OptionsMenu.entryButton.hide();
                        ShopMenu.entryButton.hide();
                        levelManager.spawnLevel();
                        break;
                }
            }
            break;
            case 'm':
                levelManager.spawnLevel();
                break;
        }
    }
    
    void keyReleased() {
        levelManager.player.checkKeys(false);
        if (DEBUG_MODE) {
            aStarTester.keyReleased();
        }
    }
}