class WeaponItem<T extends Weapon> extends Item {
    private final Class<T> weaponType;
    
    public WeaponItem(int x, int y, Class<T> weaponType) {
        super(x,y,weaponImage(weaponType));
        this.weaponType = weaponType;
    }
    
    void giveItem(Player player) {
        player.giveWeapon(weaponType);
    }
}

public PImage weaponImage(Class weaponType) {
    if (weaponType.equals(Pistol.class)) {
        return Graphics.pistol;
    }
    else if (weaponType.equals(Rifle.class)) {
        return Graphics.rifle;
    }
    else if (weaponType.equals(PulseCannon.class)) {
        return Graphics.pulseCannon;
    }
    else if (weaponType.equals(Railgun.class)) {
        return Graphics.railgun;
    }
    else if (weaponType.equals(EMPCannon.class)) {
        return Graphics.empCannon;
    }
    else{
        return Graphics.pistol; // Change to a generic item image?
    }
}

class SpeedBoostItem extends Item {
    public SpeedBoostItem(int x, int y) {
        super(x,y,Graphics.speedBoost);
    }
    
    void giveItem(Player player) {
        new SpeedBoost(player, 5000.0);
    }
}

class DamageBoostItem extends Item {
    public DamageBoostItem(int x, int y) {
        super(x,y,Graphics.damageBoost);
    }
    
    void giveItem(Player player) {
        new DamageBoost(player, 5000.0);
    }
}

class FreezeItem extends Item {
    public FreezeItem(int x, int y) {
        super(x,y,Graphics.freeze);
    }
    
    void giveItem(Player player) {
        for (Enemy enemy : ((Robotron)currentScene).levelManager.ENEMIES) {
            new Freeze(enemy, 3000.0);
        }
    }
}

abstract class Item extends GameObject {
    PImage image;
    float size;
    
    public Item(int x, int y, PImage image) {
        super(x,y);
        this.image = image;
        this.size = ((Robotron)currentScene).levelManager.cellSize / 1.2f;
    }
    
    abstract void giveItem(Player player);
    
    void update() {
        Player player = ((Robotron)currentScene).levelManager.player;
        if (player.position.copy().sub(position).mag() < player.size) {
            giveItem(player);
            destroy();
        }
    }
    
    void render() {
        tint(255);
        image(image, position.x, position.y, size, size);
    }
}