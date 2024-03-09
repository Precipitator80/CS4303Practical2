class TurretRobot extends ShootingEnemy {
    public TurretRobot(int x, int y) {
        super(x,y,null,250,0f,1,true,3000.0,50);
    }
    
    void render() {
        super.render();
        imageMode(CENTER);
        image(Graphics.turretRobot, this.position.x, this.position.y, size, size);
    }
}

class LaserRobot extends ShootingEnemy {
    public LaserRobot(int x, int y) {
        super(x,y,Graphics.laserRobotAnimator,200,0.0025f,2,false,6000.0,50);
    }
}

class FlyingRobot extends ShootingEnemy{
    public FlyingRobot(int x, int y) {
        super(x,y,Graphics.flyingRobotAnimator,75,0.005f,2,false,2000.0,25);
    }
}

class GruntRobot extends Enemy {
    public GruntRobot(int x, int y) {
        super(x,y,Graphics.gruntRobotAnimator,100,0.004f,1,false);
    }
}

abstract class ShootingEnemy extends Enemy {
    double lastShotTime;
    double shotPeriod;
    int damage;
    color laserColour = color(255,36,36);
    
    public ShootingEnemy(int x, int y, Animator animator, int hp, float movementSpeed, int points, boolean stationary, double shotPeriod, int damage) {
        super(x,y,animator,hp,movementSpeed,points,stationary);
        this.shotPeriod = shotPeriod;
        this.damage = damage;
    }
    
    void shoot() {
        Player player = ((Robotron)currentScene).levelManager.player;
        float offsetRange = new PVector(player.position.x - position.x, player.position.y - position.y).mag() / 10;
        PVector target = new PVector(random(player.position.x - offsetRange, player.position.x + offsetRange), random(player.position.y - offsetRange, player.position.y + offsetRange));
        
        PVector shotVelocity = new PVector(target.x, target.y).sub(position.x, position.y);
        shotVelocity.normalize();
        shotVelocity.mult(0.015f * height);
        
        new Laser((int)position.x,(int)position.y, shotVelocity, damage, false, laserColour);
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
    public Enemy(int x, int y, Animator animator, int hp, float movementSpeed, int points, boolean stationary) {
        super(x,y,animator,hp,movementSpeed,points,stationary);
       ((Robotron)currentScene).levelManager.ENEMIES.add(this);
    }
    
    void destroy() {
        super.destroy();
       ((Robotron)currentScene).levelManager.ENEMIES.remove(this);
    }
    
    void despawn() {
       ((Robotron)currentScene).levelManager.addPoints(points);
        super.despawn();
    }
}