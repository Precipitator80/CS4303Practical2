abstract class Item extends GameObject {
    public Item(int x, int y) {
        super(x,y);
    }
    
    void update() {
        Player player = ((Robotron)currentScene).levelManager.player;
        if (player.position.copy().sub(position).mag() < player.size / 2) {
            player.giveItem(this);
            destroy();
        }
    }
}