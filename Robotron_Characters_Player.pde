import java.util.Map;

class Player extends Character {
    color playerColour = color(0,0,160);
    Weapon currentWeapon;
    private Map<Integer, Weapon> weaponMap;
    List<Weapon> weapons;
    
    int startingLives = 2;
    int livesGained;
    int livesUsed;
    
    boolean moveUp;
    boolean moveLeft;
    boolean moveDown;
    boolean moveRight;
    
    PVector shootingDirection;
    boolean shootUp;
    boolean shootLeft;
    boolean shootDown;
    boolean shootRight;
    
    public Player(int x, int y) {
        super(x,y,Graphics.playerAnimator,100,0.008f);
        reset();
        shootingDirection = new PVector();
    }
    
    void respawn(int x, int y) {
        super.respawn(x,y);
        for (Weapon weapon : weapons) {
            weapon.refill();
        }
        new Highlight(this,1000.0,playerColour);
    }
    
    void reset() {
        // Initialise the weapons array.
        weapons = new ArrayList<Weapon>();
        weaponMap = new HashMap<Integer, Weapon>();
        
        // Give the player their starting weapon.
        giveWeapon(Pistol.class);
        livesUsed = 0;
        
        if (((Robotron)currentScene).OptionsMenu.allWeaponsAtStart.value) {
            giveWeapon(Rifle.class);
            giveWeapon(PulseCannon.class);
            giveWeapon(Railgun.class);
            giveWeapon(EMPCannon.class);
        }
    }
    
    void giveWeapon(Class<? extends Weapon> weaponType) {
        Weapon weapon = getWeapon(weaponType);
        if (weapon == null) {
            if (weaponType.equals(Pistol.class)) {
                weapon = new Pistol(position);
            }
            else if (weaponType.equals(Rifle.class)) {
                weapon = new Rifle(position);
            }
            else if (weaponType.equals(PulseCannon.class)) {
                weapon = new PulseCannon(position);
            }
            else if (weaponType.equals(Railgun.class)) {
                weapon = new Railgun(position);
            }
            else if (weaponType.equals(EMPCannon.class)) {
                weapon = new EMPCannon(position);
            }
            if (weapon != null) {
                weapons.add(weapon);
                Collections.sort(weapons);
                weaponMap.put(weapon.code, weapon);
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
    
    void checkWeaponSwitch() {
        int charValue = (int) key;
        if (weaponMap.containsKey(charValue)) {
            currentWeapon = weaponMap.get(charValue);
        }
    }
    
    void despawn() {
        if (livesLeft() > 0) {
            int x = (int)position.x;
            int y = (int)position.y;
            respawn(x,y);
            new FreezeItem(x,y).giveItem(this);
            livesUsed++;
        }
        else{
            super.despawn();
        }
    }
    
    int livesLeft() {
        return livesGained - livesUsed;
    }
    
    void update() {
        super.update();
        if (alive()) {
            if (shootingDirection.mag() > 0) {
                currentWeapon.tryToFire((int)(position.x + shootingDirection.x),(int)(position.y + shootingDirection.y));
            }
        }
    }
    
    void render() {
        if (alive()) {
            super.render();
            weaponsDisplay();
            
            if (!((Robotron)currentScene).OptionsMenu.enabled && !((Robotron)currentScene).ShopMenu.enabled) {
                // Draw the crosshair.
                noCursor();
                tint(255);
                float crosshairSize = height / 25;
                image(Graphics.crosshair, mouseX, mouseY, crosshairSize, crosshairSize);
            }
            else{
                cursor();
            }
        }
    }
    
    void weaponsDisplay() {
        for (int i = 0; i < weapons.size(); i++) {
            // Get the weapon.
            Weapon weapon = weapons.get(i);
            
            // Set base coordinates for the icon.
            float iconSize = 1.5f * size;
            float x = iconSize * (i + 1) * 1.5f;
            float y = height - iconSize;
            
            // Draw a frame.
            float fillOpacity;
            if (weapon.maxShots == 0) {
                fillOpacity = 255;
            }
            else{
                fillOpacity = 255 * ((float) weapon.currentShots / weapon.maxShots);
            }
            strokeWeight(0);
            stroke(playerColour,fillOpacity);
            fill(playerColour,fillOpacity);
            circle(x,y,iconSize);
            
            // Highlight the current weapon.
            if (weapon == currentWeapon) {
                tint(255);
            }
            else{
                tint(100);
            }
            image(weapon.image, x, y, iconSize, iconSize);
            
            // Show the key to switch to the weapon.
            float textX = x + iconSize / 2;
            float textY = y + iconSize / 2;
            fill(0);
            text((char) weapon.code, textX, textY);
        }
    }
    
    void checkKeys(boolean pressed) {
        if (pressed) { 
            checkWeaponSwitch();
        }
        
        boolean updatedMovement = false;
        switch(key) {
            case 'w':
                moveUp = pressed;
                updatedMovement = true;
                break;
            case 'a':
                moveLeft = pressed;
                updatedMovement = true;
                break;
            case 's':
                moveDown = pressed;
                updatedMovement = true;
                break;
            case 'd':
                moveRight = pressed;
                updatedMovement = true;
                break;
        }
        if (updatedMovement) {
            updateVelocity();
        }
        
        boolean updatedShooting = false;
        switch(keyCode) {
            case UP:
                shootUp = pressed;
                updatedShooting = true;
                break;
            case LEFT:
                shootLeft = pressed;
                updatedShooting = true;
                break;
            case DOWN:
                shootDown = pressed;
                updatedShooting = true;
                break;
            case RIGHT:
                shootRight = pressed;
                updatedShooting = true;
                break;                
        }
        if (updatedShooting) {
            updateKeyboardFiring();
        }
    }
    
    void updateKeyboardFiring() {
        shootingDirection.set(0, 0);
        if (shootUp) {
            shootingDirection.add(0, -1);
        }
        if (shootLeft) {
            shootingDirection.add( -1, 0);
        }
        if (shootDown) {
            shootingDirection.add(0, 1);
        }
        if (shootRight) {
            shootingDirection.add(1, 0);
        }
        shootingDirection.mult(width + height);
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
        velocity.mult(movementSpeed * height * ((Robotron)currentScene).OptionsMenu.playerSpeedMultiplier.value);
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
