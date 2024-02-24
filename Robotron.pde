public class Robotron extends Scene {
    Player player;
    public final LinkedTransferQueue<Enemy> ENEMIES = new LinkedTransferQueue<Enemy>();
    
    public Robotron() {
        super(color(255), color(128));
        player = new Player(width / 2, height / 2);
        new Enemy(width / 4, height / 2);
    }
    
    void render() {
        // Background
        background(Graphics.background);
        
        // Foreground
        super.render();
        
        // Show a message on the game's state to the player.
        fill(255);
        textSize(height / 25);
        textAlign(CENTER);
        text("Welcome to Robotron!\nPress enter to start the game.", width / 2, height / 2);
    }
    
    void mouseReleased() {
        super.mouseReleased();
        player.shoot();
    }
    
    void keyPressed() {
        player.checkMovementKeys(true);
    }
    
    void keyReleased() {
        player.checkMovementKeys(false);
    }
}