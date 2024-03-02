class Laser extends GameObject {
    PVector velocity;
    PVector renderOffset;
    final int damage;
    final boolean friendly;
    final color laserColour;
    
    public Laser(int x, int y, PVector velocity, int damage, boolean friendly, color laserColour) {
        super(x,y);
        this.velocity = velocity;
        this.renderOffset = velocity.copy().normalize().mult(0.01f * height);
        this.damage = damage;
        this.friendly = friendly;
        this.laserColour = laserColour;
    }
    
    void update() {
        position.add(velocity);
        
        LevelManager levelManager = ((Robotron)currentScene).levelManager;
        if (levelManager.insideOfWall((int)position.x,(int)position.y) || Utility.outOfBounds(this, renderOffset.mag() * 2)) {
            destroy();
        }
        else if (friendly) {
            Iterator<Enemy> iterator = ((Robotron)currentScene).levelManager.ENEMIES.iterator();
            while(iterator.hasNext()) {
                Enemy enemy = iterator.next();
                if (touchingTarget(enemy)) {
                    enemy.damage(damage);
                    this.destroy();
                }
            }
        }
        else {
            if (touchingTarget(levelManager.player)) {
                levelManager.player.damage(damage);
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
        stroke(laserColour);
        line(position.x - renderOffset.x, position.y - renderOffset.y, position.x + renderOffset.x, position.y + renderOffset.y);
    }
}