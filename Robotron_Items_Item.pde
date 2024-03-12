class WeaponItem<T extends Weapon> extends Item {
    private final Class<T> weaponType;
    PImage image;
    
    public WeaponItem(int x, int y, Class<T> weaponType) {
        super(x,y);
        this.weaponType = weaponType;
        
        if (weaponType.equals(Pistol.class)) {
            image = Graphics.pistol;
        }
        else if (weaponType.equals(Rifle.class)) {
            image = Graphics.rifle;
        }
        else{
            image = Graphics.pistol; // Change to item?
        }
    }
    
    void giveItem(Player player) {
        player.giveWeapon(weaponType);
    }
    
    void render() {
        tint(255);
        image(image, position.x, position.y, size, size);
    }
}

abstract class Item extends GameObject {
    float size;
    
    public Item(int x, int y) {
        super(x,y);
        this.size = ((Robotron)currentScene).levelManager.cellSize / 1.2f;
    }
    
    abstract void giveItem(Player player);
    
    void update() {
        Player player = ((Robotron)currentScene).levelManager.player;
        if (player.position.copy().sub(position).mag() < player.size / 2) {
            giveItem(player);
            destroy();
        }
    }
}