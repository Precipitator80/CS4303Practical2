public class RobotronScene extends Scene {
    public RobotronScene() {
        super(color(255), color(128));
    }
    
    void render() {
        super.render();
        
        // Background
        background(Graphics.background);
        
        // Show a message on the game's state to the player.
        fill(255);
        textSize(height / 25);
        textAlign(CENTER);
        text("Welcome to Robotron!\nPress enter to start the game.", width / 2, height / 2);
    }
    
    void keyPressed() {
        
    }
}