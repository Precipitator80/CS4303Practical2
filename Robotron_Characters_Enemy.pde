class BrainRobot extends ShootingEnemy {
    public BrainRobot(int x, int y) {
        super(x,y,Graphics.brainRobotAnimator,150,0.004f,3,false,true,7500.0,75,2000.0,75);
    }
    
    void update() {
        super.update();
        if (currentTarget != null && currentTarget instanceof FamilyMember && currentTarget.position.copy().sub(position).mag() < size) {
            new TransformedHuman((int)currentTarget.position.x,(int)currentTarget.position.y);
            currentTarget.destroy();
        }
    }
}

class TransformedHuman extends ShootingEnemy {
    public TransformedHuman(int x, int y) {
        super(x,y,Graphics.transformedHumanAnimator,100,0.008f,5,false,false,500.0,25,500.0,10);
    }
}

class TurretRobot extends ShootingEnemy {
    public TurretRobot(int x, int y) {
        super(x,y,null,250,0f,1,true,false,3000.0,50,0.0,0);
    }
    
    void render() {
        super.render();
        imageMode(CENTER);
        image(Graphics.turretRobot, this.position.x, this.position.y, size, size);
    }
}

class LaserRobot extends ShootingEnemy {
    public LaserRobot(int x, int y) {
        super(x,y,Graphics.laserRobotAnimator,200,0.0025f,2,false,false,6000.0,50,1500.0,50);
    }
}

class FlyingRobot extends ShootingEnemy{
    boolean altMove;
    boolean clockwise;
    
    public FlyingRobot(int x, int y) {
        super(x,y,Graphics.flyingRobotAnimator,75,0.005f,2,false,false,2000.0,25,1000.0,5);
    }
    
    public void moveCharacter() {
        if (canSeeTarget && currentTarget != null) {
            LevelManager levelManager = ((Robotron)currentScene).levelManager;
            float difference = position.copy().sub(currentTarget.position).mag();
            if (difference < 3 * levelManager.cellSize && !altMove) {
                altMove = true;
                clockwise = (int)random(2) == 1 ? true : false;
            }
            else if (difference > 4 * levelManager.cellSize) {
                altMove = false;
            }
            
            if (altMove) {
                float x = velocity.x;
                float y = velocity.y;
                if (clockwise) {
                    velocity.set(y, -x);
                }
                else{
                    velocity.set( -y,x);
                }
            }
        }
        
        super.moveCharacter();
    }
}

class GruntRobot extends Enemy {
    public GruntRobot(int x, int y) {
        super(x,y,Graphics.gruntRobotAnimator,100,0.004f,1,false,false,1500.0,25);
    }
}

class WormRobot extends Enemy {
    boolean lockingTarget;
    
    public WormRobot(int x, int y) {
        super(x,y,Graphics.wormRobotAnimator,50,0.006f,2,false,true,500.0,5);
    }
    
    void update() {
        super.update();
        if (alive() && currentTarget != null && currentTarget.position.copy().sub(position).mag() < size) {
            currentTarget.locked = true;
            lockingTarget = true;
        }
        else {
            unlockTarget();
        }
    }
    
    void despawn() {
        unlockTarget();
        super.despawn();
    }
    
    void unlockTarget() {
        if (currentTarget != null) {
            currentTarget.locked = false;
            lockingTarget = false;
        }
    }
}

abstract class ShootingEnemy extends Enemy {
    double lastShotTime;
    double shotPeriod;
    int damage;
    color laserColour = color(255,36,36);
    
    public ShootingEnemy(int x, int y, Animator animator, int hp, float movementSpeed, int points, boolean stationary, boolean attacksFamily, double shotPeriod, int damage, double meleePeriod, int meleeDamage) {
        super(x,y,animator,hp,movementSpeed,points,stationary,attacksFamily,meleePeriod,meleeDamage);
        this.shotPeriod = shotPeriod;
        this.damage = damage;
    }
    
    void shoot() {
        if (currentTarget != null && !frozen) {
            float offsetRange = new PVector(currentTarget.position.x - position.x, currentTarget.position.y - position.y).mag() / 10;
            PVector target = new PVector(random(currentTarget.position.x - offsetRange, currentTarget.position.x + offsetRange), random(currentTarget.position.y - offsetRange, currentTarget.position.y + offsetRange));
            
            PVector shotVelocity = new PVector(target.x, target.y).sub(position.x, position.y);
            shotVelocity.normalize();
            shotVelocity.mult(0.015f * height);
            
            new Laser((int)position.x,(int)position.y, shotVelocity, damage, false, laserColour);
            lastShotTime = millis();
        }
    }
    
    void update() {
        super.update();
        
        if (canSeeTarget) {
            double current = millis();
            if (current - lastShotTime > shotPeriod) {
                shoot();
            }
        }
    }
}

abstract class Enemy extends NPC {
    double lastMeleeTime;
    double meleePeriod;
    int meleeDamage;
    
    public Enemy(int x, int y, Animator animator, int hp, float movementSpeed, int points, boolean stationary, boolean attacksFamily, double meleePeriod, int meleeDamage) {
        super(x,y,animator,hp,movementSpeed,points,stationary,attacksFamily);
        this.meleePeriod = meleePeriod;
        this.meleeDamage = meleeDamage;
       ((Robotron)currentScene).levelManager.ENEMIES.add(this);
    }
    
    void update() {
        super.update();
        meleeCheck();
    }
    
    void meleeCheck() {
        if (currentTarget != null && currentTarget.position.copy().sub(position).mag() < size) {
            double current = millis();
            if (current - lastMeleeTime > meleePeriod) {
                currentTarget.damage(meleeDamage);
                lastMeleeTime = current;
            }
        }
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