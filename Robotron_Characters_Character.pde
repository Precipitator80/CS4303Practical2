abstract class Character extends GameObject {
    PVector velocity;
    boolean moveUp;
    boolean moveLeft;
    boolean moveDown;
    boolean moveRight;
    int hp;
    float movementSpeed;
    float size;
    Animator animator;
    private float currentFrame = 0.0f;
    PImage currentStill;
    
    public Character(int x, int y, Animator animator, int hp, float movementSpeed) {
        super(x,y);
        this.hp = hp;
        this.movementSpeed = movementSpeed;
        velocity = new PVector();
        this.size = height / 25;
        
        this.animator = animator;
        if (animator != null) {
            currentStill = animator.downStill;
        }
    }
    
    boolean alive() {
        return hp > 0;
    }
    
    void damage(int damage) {
        hp -= damage;
        if (!alive()) {
            despawn();
        }
    }
    
    abstract void despawn();
    
    void respawn(int x, int y) {
        position.set(x,y);
        hp = 100;
    }
    
    void update() {
        if (alive()) {
            moveCharacter();
        }
    }
    
    void render() {
        if (animator != null) {
            // Progress the animation.
            currentFrame += animator.ANIMATION_SPEED;
            
            // Decide which frame to use.
            PImage frame;
            if (velocity.mag() == 0) { // The character is still.
                frame = currentStill;
            }
            else if (abs(velocity.x) > abs(velocity.y)) { // The character is moving left or right.
                if (Math.signum(velocity.x) > 0) { // The character is moving right.
                    currentFrame %= animator.rightFrames.length;
                    frame = animator.rightFrames[(int)currentFrame];
                    currentStill = animator.rightStill;
                }
                else{ // The character is moving left.
                    currentFrame %= animator.leftFrames.length;
                    frame = animator.leftFrames[(int)currentFrame];
                    currentStill = animator.leftStill;
                }
            }
            else{ // The character is moving up or down.
                if (Math.signum(velocity.y) > 0) { // The character is moving down.
                    currentFrame %= animator.downFrames.length;
                    frame = animator.downFrames[(int)currentFrame];
                    currentStill = animator.downStill;
                }
                else{ // The character is moving up.
                    currentFrame %= animator.upFrames.length;
                    frame = animator.upFrames[(int)currentFrame];
                    currentStill = animator.upStill;
                }
            }
            
            // Render the frame.
            imageMode(CENTER);
            float scaledSize = size * animator.SCALE;
            image(frame, this.position.x, this.position.y, scaledSize, scaledSize);
        }
    }
    
    void moveCharacter() {
        if (velocity.mag() > 0) {
            // Check whether the character would end up inside of a wall with the position change.
            // Check both x and y separately, nullifying each component if required.
            LevelManager levelManager = ((Robotron)currentScene).levelManager;
            
            boolean followX = true;
            int screenX = (int)(position.x + velocity.x + Math.signum(velocity.x) * size / 2);
            if (levelManager.inaccessible(screenX,(int)(position.y - size / 2)) || levelManager.inaccessible(screenX,(int)(position.y + size / 2))) {
                followX = false;
            }
            
            boolean followY = true;
            int screenY = (int)(position.y + velocity.y + Math.signum(velocity.y) * size / 2); 
            if (levelManager.inaccessible((int)(position.x - size / 2), screenY) || levelManager.inaccessible((int)(position.x + size / 2), screenY)) {
                followY = false;
            }
            
            position.set(position.x + (followX ? velocity.x : 0), position.y + (followY ? velocity.y : 0));
        }
    }
}