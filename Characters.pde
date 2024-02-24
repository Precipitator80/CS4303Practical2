class Player extends Character {
    public Player(int x, int y) {
        super(x,y);
    }
    
    void render() {
        strokeWeight(0);
        fill(0,0,255);
        circle(position.x, position.y, size);
    }
    
    void shoot() {
        PVector shotVelocity = new PVector(mouseX, mouseY).sub(position.x, position.y);
        shotVelocity.normalize();
        shotVelocity.mult(0.02f * height);
        
        new Laser((int)position.x,(int)position.y, shotVelocity, true);
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
    boolean friendly;
    int damage;
    
    public Laser(int x, int y, PVector velocity, boolean friendly) {
        super(x,y);
        this.velocity = velocity;
        this.renderOffset = velocity.copy().normalize().mult(0.01f * height);
        this.friendly = friendly;
        this.damage = 25;
    }
    
    void update() {
        position.add(velocity);
        if (Utility.outOfBounds(this, renderOffset.mag() * 2)) {
            destroy();
        }
        else if (friendly) {
            Iterator<Enemy> iterator = ((Robotron)currentScene).ENEMIES.iterator();
            while(iterator.hasNext()) {
                Enemy enemy = iterator.next();
                if (touchingTarget(enemy)) {
                    enemy.damage(damage);
                    this.destroy();
                }
            }
        }
        else {
            Player player = ((Robotron)currentScene).player;
            if (touchingTarget(player)) {
                player.damage(damage);
                this.destroy();
            }
        }
    }
    
    boolean touchingTarget(Character target) {
        float radius = target.size / 2;
        return abs(target.position.x - position.x) < radius && abs(target.position.y - position.y) < radius;
    }
    
    void render() {
        strokeWeight(height / 150f);
        stroke(0,0,255);
        line(position.x - renderOffset.x, position.y - renderOffset.y, position.x + renderOffset.x, position.y + renderOffset.y);
    }
}

class Enemy extends Character {
    public Enemy(int x, int y) {
        super(x,y);
       ((Robotron)currentScene).ENEMIES.add(this);
    }
    
    void destroy() {
        super.destroy();
       ((Robotron)currentScene).ENEMIES.remove(this);
    }
    
    void render() {
        strokeWeight(0);
        fill(255,0,0);
        circle(position.x, position.y, size);
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
    float size;
    
    public Character(int x, int y) {
        super(x,y);
        velocity = new PVector();
        this.size = height / 25;
    }
    
    void damage(int damage) {
        hp -= damage;
        if (hp <= 0) {
            destroy();
        }
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