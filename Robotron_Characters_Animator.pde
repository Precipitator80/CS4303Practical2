class Animator {
    private final static float ANIMATION_SPEED = 0.1f;
    private float currentFrame = 0.0f;
    
    PVector position;
    PVector velocity;
    
    private PImage[] upFrames;
    private PImage upStill;
    
    private PImage[] rightFrames;
    private PImage rightStill;
    
    private PImage[] downFrames;
    private PImage downStill;
    
    private PImage[] leftFrames;
    private PImage leftStill;
    
    PImage currentStill;
    
    public Animator(PImage[] upFrames, PImage upStill,
        PImage[] rightFrames, PImage rightStill,
        PImage[] downFrames, PImage downStill,
        PImage[] leftFrames, PImage leftStill) {
        this.position = new PVector();
        this.velocity = new PVector();
        this.upFrames = upFrames;
        this.upStill = upStill;
        this.rightFrames = rightFrames;
        this.rightStill = rightStill;
        this.downFrames = downFrames;
        this.downStill = downStill;
        this.leftFrames = leftFrames;
        this.leftStill = leftStill;
        currentStill = downStill;
    }
    
    public void render() {
        // Progress the animation.
        currentFrame += ANIMATION_SPEED;
        
        // Decide which frame to use.
        PImage frame;
        if (velocity.mag() == 0) { // The character is still.
            frame = currentStill;
        }
        else if (abs(velocity.x) > abs(velocity.y)) { // The character is moving left or right.
            if (Math.signum(velocity.x) > 0) { // The character is moving right.
                frame = rightFrames[(int)currentFrame];
                currentStill = rightStill;
                currentFrame %= rightFrames.length;
            }
            else{ // The character is moving left.
                frame = leftFrames[(int)currentFrame];
                currentStill = leftStill;
                currentFrame %= leftFrames.length;
            }
        }
        else{ // The character is moving up or down.
            if (Math.signum(velocity.y) > 0) { // The character is moving down.
                frame = downFrames[(int)currentFrame];
                currentStill = downStill;
                currentFrame %= downFrames.length;
            }
            else{ // The character is moving up.
                frame = upFrames[(int)currentFrame];
                currentStill = upStill;
                currentFrame %=  upFrames.length;
            }
        }
        
        // Render the frame.
        image(frame, this.position.x, this.position.y);
    }
}
