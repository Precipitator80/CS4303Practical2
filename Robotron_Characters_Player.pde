import java.util.Map;

class Player extends Character {
    color playerColour = color(0,0,255);
    Weapon currentWeapon;
    private Map<Integer, Weapon> weaponMap;
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
        weaponMap = new HashMap<Integer, Weapon>();
        
        // Give the player their starting weapon.
        currentWeapon = new Pistol(position, playerColour);
        weapons.add(currentWeapon);
        weaponMap.put(currentWeapon.code, currentWeapon);
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
    
    void render() {
        if (alive()) {
            super.render();
            weaponsDisplay();
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