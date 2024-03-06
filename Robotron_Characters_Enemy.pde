class Enemy extends NPC {
    // General Things
    double lastShotTime;
    double shotPeriod = 3000.0;
    color enemyColour = color(255,0,0);
    
    public Enemy(int x, int y) {
        super(x,y,0.004f,1);
       ((Robotron)currentScene).levelManager.ENEMIES.add(this);
    }
    
    void shoot() {
        Player player = ((Robotron)currentScene).levelManager.player;
        float offsetRange = new PVector(player.position.x - position.x, player.position.y - position.y).mag() / 10;
        PVector target = new PVector(random(player.position.x - offsetRange, player.position.x + offsetRange), random(player.position.y - offsetRange, player.position.y + offsetRange));
        
        PVector shotVelocity = new PVector(target.x, target.y).sub(position.x, position.y);
        shotVelocity.normalize();
        shotVelocity.mult(0.015f * height);
        
        new Laser((int)position.x,(int)position.y, shotVelocity, 25, false, enemyColour);
        lastShotTime = millis();
    }
    
    void destroy() {
        super.destroy();
       ((Robotron)currentScene).levelManager.ENEMIES.remove(this);
    }
    
    void update() {
        super.update();
        
        if (canSeePlayer) {
            double current = millis();
            if (current - lastShotTime > shotPeriod) {
                shoot();
            }
        }
    }
    
    void render() {
        super.render();
        strokeWeight(0);
        stroke(enemyColour);
        fill(enemyColour);
        circle(position.x, position.y, size);
    }
}