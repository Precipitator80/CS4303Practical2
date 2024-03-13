import java.util.Comparator;

enum WeaponType {
    PISTOL,
    RIFLE,
    PULSE_CANNON,
    RAILGUN,
    EMP_CANNON
}

class Pistol extends Weapon {
    public Pistol(PVector ownerPosition, color shotColour) {
        super('1', Graphics.pistol, ownerPosition, shotColour, 0, 60.0, 0.0, true, 25);
    }
    
    protected void fire(int targetX, int targetY) {
        PVector shotVelocity = new PVector(targetX, targetY).sub(position.x, position.y);
        shotVelocity.normalize();
        shotVelocity.mult(0.015f * height);
        
        new Laser((int)position.x,(int)position.y, shotVelocity, damage * damageMultiplier, true, shotColour);
    }
}

class Rifle extends Weapon {
    public Rifle(PVector ownerPosition, color shotColour) {
        super('2', Graphics.rifle, ownerPosition, shotColour, 30, 75.0, 300.0, true, 35);
    }
    
    protected void fire(int targetX, int targetY) {
        PVector shotVelocity = new PVector(targetX, targetY).sub(position.x, position.y);
        shotVelocity.normalize();
        shotVelocity.mult(0.025f * height);
        
        new Laser((int)position.x,(int)position.y, shotVelocity, damage * damageMultiplier, true, shotColour);
    }
}

class PulseCannon extends Weapon {
    public PulseCannon(PVector ownerPosition, color shotColour) {
        super('3', Graphics.pulseCannon, ownerPosition, shotColour, 8, 75.0, 1000.0, false, 10);
    }
    
    protected void fire(int targetX, int targetY) {
        // LevelManager levelManager = ((Robotron)currentScene).levelManager;
        PVector shotVelocity = new PVector(targetX, targetY).sub(position.x, position.y);
        shotVelocity.normalize();
        for (int pellet = 0; pellet < 12; pellet++) {
            // Slightly edit the angle for each shot.
            PVector alteredShotVelocity = rotateVectorRandomly(shotVelocity, 10);
            
            // Set the speed of the shot and shoot it.
            alteredShotVelocity.mult(0.015f * height);
            new Laser((int)position.x,(int)position.y, alteredShotVelocity, damage * damageMultiplier, true, shotColour);
        }
    }
}

PVector rotateVectorRandomly(PVector vector, int maxAngle) {
    float angleDegrees = random( -maxAngle, maxAngle);
    double angleRadians = Math.toRadians(angleDegrees);
    double newX = vector.x * Math.cos(angleRadians) - vector.y * Math.sin(angleRadians);
    double newY = vector.x * Math.sin(angleRadians) + vector.y * Math.cos(angleRadians);
    return new PVector((float)newX,(float)newY);
}

class Railgun extends Weapon {
    public Railgun(PVector ownerPosition, color shotColour) {
        super('4', Graphics.railgun, ownerPosition, shotColour, 3, 250.0, 5000.0, false, 100);
    }
    
    protected void fire(int targetX, int targetY) {        
        new RailgunLaser((int)position.x,(int)position.y, targetX, targetY, damage * damageMultiplier, true, shotColour);
    }
}

class EMPCannon extends Weapon {
    public EMPCannon(PVector ownerPosition, color shotColour) {
        super('5', Graphics.empCannon, ownerPosition, shotColour, 6, 150.0, 2500.0, false, 200);
    }
    
    protected void fire(int targetX, int targetY) {
        PVector shotVelocity = new PVector(targetX, targetY).sub(position.x, position.y);
        shotVelocity.normalize();
        shotVelocity.mult(0.025f * height);
        
        new EMPCannonLaser((int)position.x,(int)position.y, shotVelocity, damage * damageMultiplier, true, shotColour);
    }
}

abstract class Weapon extends GameObject implements Comparable<Weapon> {
    final int code;
    final PImage image;
    
    final color shotColour;
    
    final int maxShots;
    int currentShots;
    
    final double fireDelay;
    double lastFired;
    
    final double rechargeDelay;
    double lastRecharged;
    
    final boolean automatic;
    final int damage;
    int damageMultiplier = 1;
    
    public Weapon(char code, PImage image, PVector ownerPosition, color shotColour, int maxShots, double fireDelay, double rechargeDelay, boolean automatic, int damage) {
        super(0,0);
        this.code = (int) code;
        this.image = image;
        position = ownerPosition;
        this.shotColour = shotColour;
        this.maxShots = maxShots;
        this.currentShots = maxShots;
        this.fireDelay = fireDelay;
        this.rechargeDelay = rechargeDelay;
        this.automatic = automatic;
        this.damage = damage;
    }
    
    void refill() {
        this.currentShots = maxShots;
    }
    
    void tryToFire(int targetX, int targetY) {
        double current = millis();
        double elapsedSinceFired = current - lastFired;
        if (elapsedSinceFired > fireDelay && (currentShots > 0 || maxShots == 0)) {
            fire(targetX, targetY);
            if (maxShots > 0) {
                currentShots--;
            }
            lastFired = current;
        }
    }
    
    void update() {
        if (maxShots > 0) {
            double current = millis();
            if (currentShots == maxShots) {
                lastRecharged = current;
            }
            else{
                double elapsedSinceRecharge = current - lastRecharged;
                if (elapsedSinceRecharge > rechargeDelay) {
                    currentShots++;
                    lastRecharged = current;
                }
            }
        }
    }
    
    void render() {
        
    }
    
    protected abstract void fire(int targetX, int targetY);
    
    @Override
    public int compareTo(Weapon other) {
        return Integer.compare(this.code, other.code);
    }
}