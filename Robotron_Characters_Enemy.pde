class TurretRobot extends ShootingEnemy {
    public TurretRobot(int x, int y) {
        super(x,y,null,0f,1,true);
    }
    
    void render() {
        super.render();
        imageMode(CENTER);
        image(Graphics.turretRobot, this.position.x, this.position.y, size, size);
    }
}

class LaserRobot extends ShootingEnemy {
    public LaserRobot(int x, int y) {
        super(x,y,Graphics.laserRobotAnimator,0.0025f,2,false);
    }
}

class GruntRobot extends Enemy {
    public GruntRobot(int x, int y) {
        super(x,y,Graphics.gruntRobotAnimator,0.004f,1,false);
    }
}

abstract class ShootingEnemy extends Enemy {
    double lastShotTime;
    double shotPeriod = 3000.0;
    color laserColour = color(255,36,36);
    
    public ShootingEnemy(int x, int y, Animator animator, float movementSpeed, int points, boolean stationary) {
        super(x,y,animator,movementSpeed,points,stationary);
    }
    
    void shoot() {
        Player player = ((Robotron)currentScene).levelManager.player;
        float offsetRange = new PVector(player.position.x - position.x, player.position.y - position.y).mag() / 10;
        PVector target = new PVector(random(player.position.x - offsetRange, player.position.x + offsetRange), random(player.position.y - offsetRange, player.position.y + offsetRange));
        
        PVector shotVelocity = new PVector(target.x, target.y).sub(position.x, position.y);
        shotVelocity.normalize();
        shotVelocity.mult(0.015f * height);
        
        new Laser((int)position.x,(int)position.y, shotVelocity, 25, false, laserColour);
        lastShotTime = millis();
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
}

abstract class Enemy extends NPC {
    public Enemy(int x, int y, Animator animator, float movementSpeed, int points, boolean stationary) {
        super(x,y,animator,movementSpeed,points,stationary);
       ((Robotron)currentScene).levelManager.ENEMIES.add(this);
    }
    
    void destroy() {
        super.destroy();
       ((Robotron)currentScene).levelManager.ENEMIES.remove(this);
    }
}