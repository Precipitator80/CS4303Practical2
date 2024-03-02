class Player extends Character {
    color playerColour = color(0,0,255);
    Weapon currentWeapon;
    List<Weapon> weapons;
    
    public Player(int x, int y) {
        super(x,y,0.008f);
        currentWeapon = new Pistol(position, playerColour);
        weapons = new ArrayList<Weapon>();
        weapons.add(currentWeapon);
    }
    
    void giveItem(Item item) {
        
    }
    
    void despawn() {
    }
    
    void render() {
        if (alive()) {
            stroke(playerColour);
            fill(playerColour);
        }
        else{
            stroke(playerColour, 100);
            fill(playerColour, 100);
        }
        strokeWeight(0);
        circle(position.x, position.y, size);
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