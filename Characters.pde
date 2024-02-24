class Player extends Character {
    public Player(int x, int y) {
        super(x,y);
    }
    
    void render() {
        // Rendering player!
        strokeWeight(0);
        fill(0,0,255);
        circle(position.x, position.y, height / 25);
    }
    
    void shoot() {
        PVector shotVelocity = new PVector(mouseX, mouseY).sub(position.x, position.y);
        shotVelocity.normalize();
        shotVelocity.mult(0.02f * height);
        
        new Laser((int)position.x,(int)position.y, shotVelocity);
    }
    
    void checkMovementKeys(boolean pressed) {
        switch(key) {
            case 'w':
                moveUp = pressed;
                break;
            case 'a':
                moveLeft = pressed;
                break;
            case 's':
                moveDown = pressed;
                break;
            case 'd':
                moveRight = pressed;
                break;
        }
        updateVelocity();
    }
}

class Laser extends GameObject {
    PVector velocity;
    PVector renderOffset;
    
    public Laser(int x, int y, PVector velocity) {
        super(x,y);
        this.velocity = velocity;
        this.renderOffset = velocity.copy().normalize().mult(0.01f * height);
    }
    
    void update() {
        position.add(velocity);
        if (Utility.outOfBounds(this, renderOffset.mag() * 2)) {
            destroy();
        }
    }
    
    void render() {
        strokeWeight(height / 150f);
        stroke(0,0,255);
        line(position.x - renderOffset.x, position.y - renderOffset.y, position.x + renderOffset.x, position.y + renderOffset.y);
    }
}


abstract class Character extends GameObject {
    PVector velocity;
    boolean moveUp;
    boolean moveLeft;
    boolean moveDown;
    boolean moveRight;
    int hp = 100;
    float movementSpeed = 0.004f;
    
    public Character(int x, int y) {
        super(x,y);
        velocity = new PVector();
    }
    
    
    void update() {
        moveCharacter();
    }
    
    void updateVelocity() {
        velocity.set(0, 0);
        if (moveUp) {
            velocity.add(0, -1);
        }
        if (moveLeft) {
            velocity.add( -1, 0);
        }
        if (moveDown) {
            velocity.add(0, 1);
        }
        if (moveRight) {
            velocity.add(1, 0);
        }
        velocity.normalize();
        velocity.mult(movementSpeed * height);
    }
    
    void moveCharacter() {
        position.add(velocity);
    }
}