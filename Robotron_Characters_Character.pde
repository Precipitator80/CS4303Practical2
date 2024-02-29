abstract class Character extends GameObject {
    PVector velocity;
    boolean moveUp;
    boolean moveLeft;
    boolean moveDown;
    boolean moveRight;
    int hp = 100;
    float movementSpeed;
    float size;
    
    public Character(int x, int y, float movementSpeed) {
        super(x,y);
        this.movementSpeed = movementSpeed;
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
        
        // Check whether the character is inside of a wall.
        // LevelManager levelManager = ((Robotron)currentScene).levelManager;
        // if (levelManager.insideOfWall((int)position.x,(int)position.y)) {
        //     // Try to correct the y position.
        //     position.set(position.x, position.y - velocity.y);
        //     if (levelManager.insideOfWall((int)position.x,(int)position.y)) {
        //         // Still inside of the wall with y correction. Undo and try x instead.
        //         position.set(position.x - velocity.x, position.y + velocity.y);
        //         if (levelManager.insideOfWall((int)position.x,(int)position.y)) {
        //             // Still inside of the wall with both correcitons. Undo both, keeping the character stationary.
        //             position.set(position.x, position.y - velocity.y);
        //         }
        //     }
// }
}
}