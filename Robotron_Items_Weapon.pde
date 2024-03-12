enum WeaponType {
    PISTOL,
    RIFLE,
    PULSE_CANNON,
    RAILGUN,
    EMP_CANNON
}

class Pistol extends Weapon {
    public Pistol(PVector ownerPosition, color shotColour) {
        super(ownerPosition, shotColour, 0, 60.0, 0.0, true, 25);
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
        super(ownerPosition, shotColour, 30, 75.0, 300.0, true, 35);
    }
    
    protected void fire(int targetX, int targetY) {
        PVector shotVelocity = new PVector(targetX, targetY).sub(position.x, position.y);
        shotVelocity.normalize();
        shotVelocity.mult(0.02f * height);
        
        new Laser((int)position.x,(int)position.y, shotVelocity, damage * damageMultiplier, true, shotColour);
    }
}

abstract class Weapon extends GameObject {
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
    
    public Weapon(PVector ownerPosition, color shotColour, int maxShots, double fireDelay, double rechargeDelay, boolean automatic, int damage) {
        super(0,0);
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
}