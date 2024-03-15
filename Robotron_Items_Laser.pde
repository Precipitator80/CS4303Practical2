class RailgunLaser extends LaserBase {
    int targetX;
    int targetY;
    PVector lengthVector;
    
    public RailgunLaser(int x, int y, int targetX, int targetY, int damage, float breadthMultiplier, boolean friendly) {
        super(x,y,damage,breadthMultiplier,100,1000.0,friendly,Graphics.playerLaser);
        this.targetX = targetX;
        this.targetY = targetY;
        raycastHitDetection();
        lengthVector = new PVector(this.targetX, this.targetY).sub(position);
        this.length = lengthVector.mag();
    }
    
    void raycastHitDetection() {
        LevelManager levelManager = ((Robotron)currentScene).levelManager;
        PVector origin = position;
        float step = levelManager.cellSize / 2f;
        PVector fullDifferenceVector = new PVector(targetX, targetY).sub(origin).mult(width + height);
        PVector stepDifferenceVector = fullDifferenceVector.copy().normalize().mult(step);
        PVector testVector = stepDifferenceVector.copy();
        int numberOfIterations = (int)(fullDifferenceVector.mag() / step);
        for (int i = 0; i < numberOfIterations; i++) {
            PVector positionToCheck = origin.copy().add(testVector);
            int x = (int)positionToCheck.x;
            int y = (int)positionToCheck.y;            
            
            if (levelManager.collisionCheck(x,y)) {
                int gridX = levelManager.screenToGridX(x);
                int gridY = levelManager.screenToGridY(y);
                if (levelManager.grid[gridY][gridX] instanceof Electrode) {
                   ((Electrode)levelManager.grid[gridY][gridX]).convert();
                }
                else { // This is a wall so should be the end of the laser.
                    targetX = x;
                    targetY = y;
                    break;
                }
            }
            
            hitDetection(x,y);
            testVector.add(stepDifferenceVector);
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

class EMPCannonLaser extends Laser {
    public EMPCannonLaser(int x, int y, PVector velocity, int damage, float breadthMultiplier, boolean friendly) {
        super(x,y,velocity,damage,breadthMultiplier,friendly);
    }
    
    void spawnBursts() {
        for (int burst = 0; burst < 8 + ((Robotron)currentScene).ShopMenu.empCannonExplosionBurstIncrease.timesBought; burst++) {
            PVector alteredShotVelocity = rotateVectorRandomly(velocity, 360);
            new Laser((int)position.x,(int)position.y,alteredShotVelocity,damage / 5,0.75f,75.0,friendly);
        }
        Audio.playWithProtection(Audio.pulseCannon, 1f, Audio.audioPan(position.x), 0.3f);
    }
    
    void destroy() {
        // Spawn bursts around the impact point.
        spawnBursts();
        super.destroy();
    }
}

class Laser extends LaserBase {
    PVector velocity;
    
    public Laser(int x, int y, PVector velocity, int damage, float breadthMultiplier, double lifetime, boolean friendly) {
        super(x,y,damage,breadthMultiplier,0,lifetime,friendly,friendly ? Graphics.playerLaser : Graphics.enemyLaser);
        this.velocity = velocity;
    }
    
    public Laser(int x, int y, PVector velocity, int damage, float breadthMultiplier, boolean friendly) {
        this(x,y,velocity,damage,breadthMultiplier,10000.0,friendly);
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
    public LaserBase(int x, int y, int damage, float breadthMultiplier, int pierce, double lifetime, boolean friendly, PImage image) {
        super(x,y);
        this.damage = damage;
        this.pierce = pierce;
        this.lifetime = lifetime;
        this.friendly = friendly;
        this.image = image;
        breadth = 0.01f * height * breadthMultiplier;
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
        //float radius = target.size / 2;
        //return abs(target.position.x - x) < radius + breadth / 2 && abs(target.position.y - y) < radius + breadth / 2;
        return new PVector(x,y).sub(target.position).mag() < target.size / 2 + breadth / 2;
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
