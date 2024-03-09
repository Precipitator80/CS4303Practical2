class Player extends Character {
    color playerColour = color(0,0,255);
    Weapon currentWeapon;
    List<Weapon> weapons;
    
    public Player(int x, int y) {
        super(x,y,Graphics.playerAnimator,100,0.008f);
        reset();
    }
    
    void giveItem(Item item) {
        
    }
    
    void despawn() {
    }
    
    void reset() {
        currentWeapon = new Pistol(position, playerColour);
        weapons = new ArrayList<Weapon>();
        weapons.add(currentWeapon);
    }
    
    void render() {
        if (alive()) {
            super.render();
        }
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
}