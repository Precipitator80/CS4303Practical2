class RailgunLaser extends LaserBase {
    int targetX;
    int targetY;
    PVector lengthVector;
    
    public RailgunLaser(int x, int y, int targetX, int targetY, int damage, boolean friendly) {
        super(x,y,damage,100,1000.0,friendly,Graphics.playerLaser);
        this.targetX = targetX;
        this.targetY = targetY;
        lengthVector = new PVector(targetX, targetY).sub(position);
        this.length = lengthVector.mag();
        raycastHitDetection();
    }
    
    void raycastHitDetection() {
        LevelManager levelManager = ((Robotron)currentScene).levelManager;
        PVector origin = position;
        PVector differenceVector = new PVector(targetX, targetY).sub(origin);
        float step = levelManager.cellSize / 2f;
        PVector stepDifferenceVector = differenceVector.copy().normalize().mult(step);
        int numberOfIterations = (int)(differenceVector.mag() / step);
        
        for (int i = 0; i < numberOfIterations; i++) {
            PVector positionToCheck = origin.copy().add(differenceVector);
            hitDetection((int)positionToCheck.x,(int)positionToCheck.y);
            differenceVector.sub(stepDifferenceVector);
        }
    }
    
    void render() {        
        pushMatrix();
        translate(position.x, position.y);
        rotate(atan2(lengthVector.y, lengthVector.x));
        imageMode(CENTER);
        tint(255, 255 - (255 * (float)((millis() - timeFired) / lifetime)));
        image(image, length / 2, 0, length, breadth);
        popMatrix();
    }
}

class EMPCannonLaser extends Laser{
    public EMPCannonLaser(int x, int y, PVector velocity, int damage, boolean friendly) {
        super(x,y,velocity,damage,friendly);
    }
    
    void spawnBursts() {
        for (int burst = 0; burst < 15; burst++) {
            PVector alteredShotVelocity = rotateVectorRandomly(velocity, 360);
            new Laser((int)position.x,(int)position.y,alteredShotVelocity,damage / 5,50.0,friendly);
        }
    }
    
    void destroy() {
        // Spawn bursts around the impact point.
        spawnBursts();
        super.destroy();
    }
}

class Laser extends LaserBase {
    PVector velocity;
    
    public Laser(int x, int y, PVector velocity, int damage, double lifetime, boolean friendly) {
        super(x,y,damage,0,lifetime,friendly,friendly ? Graphics.playerLaser : Graphics.enemyLaser);
        this.velocity = velocity;
    }
    
    public Laser(int x, int y, PVector velocity, int damage, boolean friendly) {
        this(x,y,velocity,damage,10000.0,friendly);
    }
    
    void update() {
        super.update();
        position.add(velocity);
        hitDetection();
    }
    
    void render() {
        pushMatrix();
        translate(position.x, position.y);
        rotate(atan2(velocity.y, velocity.x));
        imageMode(CENTER);
        tint(255);
        image(image, 0, 0, length, breadth);
        popMatrix();
    }
}

abstract class LaserBase extends GameObject {
    final int damage;
    int pierce;
    final boolean friendly;
    float length;
    float breadth;
    
    double timeFired;
    double lifetime = 1000.0;
    
    PImage image;
    public LaserBase(int x, int y, int damage, int pierce, double lifetime, boolean friendly, PImage image) {
        super(x,y);
        this.damage = damage;
        this.pierce = pierce;
        this.lifetime = lifetime;
        this.friendly = friendly;
        this.image = image;
        breadth = 0.01f * height;
        length = 2.5f * breadth;
        timeFired = millis();
    }
    
    void hitDetection() {
        hitDetection((int)position.x,(int)position.y);
    }
    
    void hitDetection(int x, int y) {        
        LevelManager levelManager = ((Robotron)currentScene).levelManager;
        if (levelManager.collisionCheck(x,y)) {
            int gridX = levelManager.screenToGridX((int) position.x);
            int gridY = levelManager.screenToGridY((int) position.y);
            if (levelManager.grid[gridY][gridX] instanceof Electrode) {
               ((Electrode)levelManager.grid[gridY][gridX]).convert();
            }
            decrementPierce();
        }
        else if (friendly) {
            Iterator<Enemy> iterator = ((Robotron)currentScene).levelManager.ENEMIES.iterator();
            while(iterator.hasNext()) {
                Enemy enemy = iterator.next();
                checkTarget(x,y,enemy);
            }
        }
        else {
            checkTarget(x,y,levelManager.player);
        }
    }
    
    void checkTarget(int x, int y, Character target) {
        if (touchingTarget(x,y,target)) {
            target.damage(damage);
            decrementPierce();
        }
    }
    
    boolean touchingTarget(int x, int y, Character target) {
        float radius = target.size / 2;
        return abs(target.position.x - x) < radius && abs(target.position.y - y) < radius;
    }
    
    void decrementPierce() {
        pierce--;
        if (pierce < 0) {
            destroy();
        }
    }
    
    void update() {
        if (millis() - timeFired > lifetime) {
            destroy();
        }
    }
}