abstract class Character extends GameObject {
    PVector velocity;
    boolean moveUp;
    boolean moveLeft;
    boolean moveDown;
    boolean moveRight;
    float movementSpeed;
    
    int hp;
    boolean locked; // Whether the character can move or not.
    boolean frozen; // Whether the character can do any action or not.
    boolean damaged; // Whether the character was damaged this frame.
    
    float size;
    Animator animator;
    private float currentFrame = 0.0f;
    PImage currentStill;
    
    double damagedTime;
    
    
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
        if (damage > 0) {
            hp -= damage;
            damaged = true;
            damagedTime = millis();
            if (!alive()) {
                despawn();
            }
        }
    }
    
    abstract void despawn();
    
    void respawn(int x, int y) {
        position.set(x,y);
        hp = 100;
        locked = false;
        frozen = false;
    }
    
    void update() {
        if (alive()) {
            moveCharacter();
        }
    }
    
    void checkDamagedTimer() {
        if (millis() - damagedTime > 100.0) {
            damaged = false;
        }
    }
    
    void render() {
        if (damaged && frozen) {
            tint(100, 153, 204);
            checkDamagedTimer();
        }
        else if (damaged) {
            tint(255,36,36);
            checkDamagedTimer();   
        }
        else if (frozen) {
            tint(0, 153, 204);
        } else{
            tint(255);
        }
        
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
        if (velocity.mag() > 0 && !frozen && !locked) {
            // Check whether the character would end up inside of a wall with the position change.
            // Check both x and y separately, nullifying each component if required.
            LevelManager levelManager = ((Robotron)currentScene).levelManager;  
            
            boolean followX = true;
            int screenX = (int)(position.x + velocity.x + Math.signum(velocity.x) * size / 2);
            boolean outOfBoundsYMinus = levelManager.impassable(screenX,(int)(position.y - size / 2));
            boolean outOfBoundsYPlus = levelManager.impassable(screenX,(int)(position.y + size / 2));
            
            boolean followY = true;
            int screenY = (int)(position.y + velocity.y + Math.signum(velocity.y) * size / 2); 
            boolean outOfBoundsXMinus = levelManager.impassable((int)(position.x - size / 2), screenY);
            boolean outOfBoundsXPlus = levelManager.impassable((int)(position.x + size / 2), screenY);
            
            if (outOfBoundsYMinus || outOfBoundsYPlus) {
                followX = false;
                
                // XOR Y
                if (outOfBoundsYMinus && !outOfBoundsYPlus) {
                    position.add(new PVector(0f, abs(velocity.x)));
                }
                else if (!outOfBoundsYMinus && outOfBoundsYPlus) {
                    position.add(new PVector(0f, -abs(velocity.x)));
                }
            }
            
            if (outOfBoundsXMinus || outOfBoundsXPlus) {
                followY = false;
                
                // XOR X
                if (outOfBoundsXMinus && !outOfBoundsXPlus) {
                    position.add(new PVector(abs(velocity.y), 0f));
                }
                else if (!outOfBoundsXMinus && outOfBoundsXPlus) {
                    position.add(new PVector( -abs(velocity.y), 0f));
                }
            }            
            
            position.set(position.x + (followX ? velocity.x : 0), position.y + (followY ? velocity.y : 0));
        }
    }
}