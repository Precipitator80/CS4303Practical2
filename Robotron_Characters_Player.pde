class Player extends Character {
    color playerColour = color(0,0,255);
    Weapon currentWeapon;
    List<Weapon> weapons;
    
    public Player(int x, int y) {
        super(x,y,Graphics.playerAnimator,100,0.008f);
        reset();
    }
    
    void respawn(int x, int y) {
        super.respawn(x,y);
        for (Weapon weapon : weapons) {
            weapon.refill();
        }
    }
    
    void reset() {
        // Initialise the weapons array.
        weapons = new ArrayList<Weapon>();
        
        // Give the player their starting weapon.
        currentWeapon = new Pistol(position, playerColour);
        weapons.add(currentWeapon);
    }
    
    void giveWeapon(Class<? extends Weapon> weaponType) {
        Weapon weapon = getWeapon(weaponType);
        if (weapon == null) {
            if (weaponType.equals(Pistol.class)) {
                weapon = new Pistol(position, playerColour);
            }
            else if (weaponType.equals(Rifle.class)) {
                weapon = new Rifle(position, playerColour);
            }
            else if (weaponType.equals(PulseCannon.class)) {
                weapon = new PulseCannon(position, playerColour);
            }
            else if (weaponType.equals(Railgun.class)) {
                weapon = new Railgun(position, playerColour);
            }
            else if (weaponType.equals(EMPCannon.class)) {
                weapon = new EMPCannon(position, playerColour);
            }
            if (weapon != null) {
                weapons.add(weapon);
                currentWeapon = weapon;
            }
        }
        else{
            weapon.refill();
        }
    }
    
    Weapon getWeapon(Class<? extends Weapon> weaponType) {
        for (Weapon weapon : weapons) {
            if (weaponType.isInstance(weapon)) {
                return weapon;
            }
        }
        return null;
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
    
    void moveCharacter() {
        if (velocity.mag() > 0 && !frozen && !locked) {
            PVector newPosition = position.copy().add(velocity);
            newPosition.add(velocity.copy().normalize().mult(size / 2));
            
            LevelManager levelManager = ((Robotron)currentScene).levelManager;
            int x = levelManager.screenToGridX((int)newPosition.x);
            int y = levelManager.screenToGridY((int)newPosition.y);
            if (levelManager.grid[y][x] instanceof Electrode) {
               ((Electrode)levelManager.grid[y][x]).collide(this);
            }
            
            //int playerX = levelManager.screenToGridX((int)position.x);
            //int playerY = levelManager.screenToGridY((int)position.y);
            //print("Current position: " + position + ". New Position: " + newPosition + "\n");
            //print("Current position: " + playerX + "," + playerY + ". New Position: " + x + "," + y + "\n");   
        }
        super.moveCharacter();
    }
}