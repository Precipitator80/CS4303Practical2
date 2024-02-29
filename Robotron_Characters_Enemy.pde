class Enemy extends Character {
    double lastShotTime;
    double shotPeriod = 3000.0;
    color enemyColour = color(255,0,0);
    
    public Enemy(int x, int y) {
        super(x,y,0.004f);
       ((Robotron)currentScene).ENEMIES.add(this);
    }
    
    void shoot() {
        Player player = ((Robotron)currentScene).player;
        float offsetRange = new PVector(player.position.x - position.x, player.position.y - position.y).mag() / 10;
        PVector target = new PVector(random(player.position.x - offsetRange, player.position.x + offsetRange), random(player.position.y - offsetRange, player.position.y + offsetRange));
        
        PVector shotVelocity = new PVector(target.x, target.y).sub(position.x, position.y);
        shotVelocity.normalize();
        shotVelocity.mult(0.015f * height);
        
        new Laser((int)position.x,(int)position.y, shotVelocity, 25, false, enemyColour);
        lastShotTime = millis();
    }
    
    boolean canSeePlayer() {
        return true; // Nothing special for now.
    }
    
    void destroy() {
        super.destroy();
       ((Robotron)currentScene).ENEMIES.remove(this);
    }
    
    void update() {
        super.update();
        
        if (canSeePlayer()) {
            double elapsed = millis() - lastShotTime;
            if (elapsed > shotPeriod) {
                shoot();
            }
        }
    }
    
    void render() {
        strokeWeight(0);
        stroke(enemyColour);
        fill(enemyColour);
        circle(position.x, position.y, size);
    }
}