public class Robotron extends Scene {
    Player player;
    public final LinkedTransferQueue<Enemy> ENEMIES = new LinkedTransferQueue<Enemy>();
    LevelManager levelManager;
    
    AStarTester aStarTester;
    
    public Robotron() {
        super(color(255), color(128));
        player = new Player(width / 6, height / 4);
        new Enemy(5 * width / 6, 3 * height / 4);
        
        // 16 by 9 times 2
        levelManager = new LevelManager(32, 18);
        levelManager.spawnLevel();
    }
    
    void update() {
        super.update();
        if (BUTTON_MANAGER.mouseDown && player.currentWeapon.automatic) {
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
        
        aStarTester.render();
        
        // Show a message on the game's state to the player.
        fill(255);
        textSize(height / 25);
        textAlign(CENTER);
        text("Welcome to Robotron: 4303!\nPress enter to start the game.", width / 2, height / 2);
    }
    
    void mousePressed() {
        super.mousePressed();
        player.currentWeapon.tryToFire(mouseX, mouseY);
    }
    
    void mouseReleased() {
        super.mouseReleased();
        aStarTester.mouseReleased();
    }
    
    void keyPressed() {
        player.checkMovementKeys(true);
    }
    
    void keyReleased() {
        player.checkMovementKeys(false);
        if (key == ' ') {
            levelManager.spawnLevel();
        }
        aStarTester.keyReleased();
    }
}