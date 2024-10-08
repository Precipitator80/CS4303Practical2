import java.util.Comparator;

enum WeaponType {
    PISTOL,
    RIFLE,
    PULSE_CANNON,
    RAILGUN,
    EMP_CANNON
}

class Pistol extends Weapon {
    public Pistol(PVector ownerPosition) {
        super('1', Graphics.pistol, ownerPosition, 0, 60.0, 0.0, 25);
    }
    
    protected void fire(int targetX, int targetY) {
        PVector shotVelocity = new PVector(targetX, targetY).sub(position.x, position.y);
        shotVelocity.normalize();
        shotVelocity.mult(0.015f * height);
        
        new Laser((int)position.x,(int)position.y, shotVelocity,(int)(damage * damageBoostMultiplier * shopDamageMultiplier()  * ((Robotron)currentScene).OptionsMenu.playerWeaponDamageMultiplier.value), 1f, true);
        Audio.playWithProtection(Audio.pistol, 1f, Audio.audioPan(position.x), 0.3f);
    }
    
    protected float shopDamageMultiplier() {
        return 1f + 0.1f * ((Robotron)currentScene).ShopMenu.pistolDamageIncrease.timesBought;
    }
    
    protected float shopRechargeDelayMultiplier() {
        return 1f;
    }
}

class Rifle extends Weapon {
    public Rifle(PVector ownerPosition) {
        super('2', Graphics.rifle, ownerPosition, 30, 75.0, 250.0, 50);
    }
    
    protected void fire(int targetX, int targetY) {
        PVector shotVelocity = new PVector(targetX, targetY).sub(position.x, position.y);
        shotVelocity.normalize();
        shotVelocity.mult(0.025f * height);
        
        new Laser((int)position.x,(int)position.y, shotVelocity,(int)(damage * damageBoostMultiplier * shopDamageMultiplier() * ((Robotron)currentScene).OptionsMenu.playerWeaponDamageMultiplier.value), 1.5f, true);
        Audio.playWithProtection(Audio.rifle, 1f, Audio.audioPan(position.x), 0.3f);
    } 
    
    protected float shopDamageMultiplier() {
        return 1f + 0.2f * ((Robotron)currentScene).ShopMenu.rifleDamageIncrease.timesBought;
    }
    
    protected float shopRechargeDelayMultiplier() {
        return constrain(1f - 0.1f * ((Robotron)currentScene).ShopMenu.rifleRechargeRateIncrease.timesBought, 0f, 1f);
    }
    
    protected float shopFireDelayMultiplier() {
        return constrain(1f - 0.1f * ((Robotron)currentScene).ShopMenu.rifleFireRateIncrease.timesBought, 0.05f, 1f);
    }
}

class PulseCannon extends Weapon {
    public PulseCannon(PVector ownerPosition) {
        super('3', Graphics.pulseCannon, ownerPosition, 8, 150.0, 1000.0, 10);
    }
    
    protected void fire(int targetX, int targetY) {
        // LevelManager levelManager = ((Robotron)currentScene).levelManager;
        PVector shotVelocity = new PVector(targetX, targetY).sub(position.x, position.y);
        shotVelocity.normalize();
        for (int pellet = 0; pellet < 10 + ((Robotron)currentScene).ShopMenu.pulseCannonBurstCountIncrease.timesBought; pellet++) {
            // Slightly edit the angle for each shot.
            PVector alteredShotVelocity = rotateVectorRandomly(shotVelocity, 10);
            
            // Set the speed of the shot and shoot it.
            alteredShotVelocity.mult(0.015f * height);
            new Laser((int)position.x,(int)position.y, alteredShotVelocity,(int)(damage * damageBoostMultiplier * shopDamageMultiplier() * ((Robotron)currentScene).OptionsMenu.playerWeaponDamageMultiplier.value), 0.85f, true);
        }
        Audio.playWithProtection(Audio.pulseCannon, 1f, Audio.audioPan(position.x), 0.3f);
    }   
    
    protected float shopDamageMultiplier() {
        return 1f + 0.2f * ((Robotron)currentScene).ShopMenu.pulseCannonDamageIncrease.timesBought;
    }
    
    protected float shopRechargeDelayMultiplier() {
        return constrain(1f - 0.1f * ((Robotron)currentScene).ShopMenu.pulseCannonRechargeRateIncrease.timesBought, 0f, 1f);
    }
}

class Railgun extends Weapon {
    public Railgun(PVector ownerPosition) {
        super('4', Graphics.railgun, ownerPosition, 3, 500.0, 5000.0, 100);
    }
    
    protected void fire(int targetX, int targetY) {        
        new RailgunLaser((int)position.x,(int)position.y, targetX, targetY,(int)(damage * damageBoostMultiplier * shopDamageMultiplier() * ((Robotron)currentScene).OptionsMenu.playerWeaponDamageMultiplier.value), 3f + 0.75f * ((Robotron)currentScene).ShopMenu.railgunBeamWidthIncrease.timesBought, true);
        Audio.playWithProtection(Audio.railgun, 1f, Audio.audioPan(position.x), 0.3f);
    }
    
    protected float shopDamageMultiplier() {
        return 1f + 0.2f * ((Robotron)currentScene).ShopMenu.railgunDamageIncrease.timesBought;
    }
    
    protected float shopRechargeDelayMultiplier() {
        return constrain(1f - 0.1f * ((Robotron)currentScene).ShopMenu.railgunRechargeRateIncrease.timesBought, 0f, 1f);
    }
}

class EMPCannon extends Weapon {
    public EMPCannon(PVector ownerPosition) {
        super('5', Graphics.empCannon, ownerPosition, 6, 250.0, 2500.0, 200);
    }
    
    protected void fire(int targetX, int targetY) {
        PVector shotVelocity = new PVector(targetX, targetY).sub(position.x, position.y);
        shotVelocity.normalize();
        shotVelocity.mult(0.025f * height);
        
        new EMPCannonLaser((int)position.x,(int)position.y, shotVelocity,(int)(damage * damageBoostMultiplier * shopDamageMultiplier() * ((Robotron)currentScene).OptionsMenu.playerWeaponDamageMultiplier.value), 2f, true);
        Audio.playWithProtection(Audio.empCannon, 1f, Audio.audioPan(position.x), 0.3f);
    }
    
    protected float shopDamageMultiplier() {
        return 1f + 0.2f * ((Robotron)currentScene).ShopMenu.empCannonDamageIncrease.timesBought;
    }
    
    protected float shopRechargeDelayMultiplier() {
        return constrain(1f - 0.1f * ((Robotron)currentScene).ShopMenu.empCannonRechargeRateIncrease.timesBought, 0f, 1f);
    }
}

PVector rotateVectorRandomly(PVector vector, int maxAngle) {
    float angleDegrees = random( -maxAngle, maxAngle);
    double angleRadians = Math.toRadians(angleDegrees);
    double newX = vector.x * Math.cos(angleRadians) - vector.y * Math.sin(angleRadians);
    double newY = vector.x * Math.sin(angleRadians) + vector.y * Math.cos(angleRadians);
    return new PVector((float)newX,(float)newY);
}

abstract class Weapon extends GameObject implements Comparable<Weapon> {
    final int code;
    final PImage image;
    
    final int maxShots;
    int currentShots;
    
    final double fireDelay;
    double lastFired;
    
    final double rechargeDelay;
    double lastRecharged;
    
    final int damage;
    int damageBoostMultiplier = 1;
    
    public Weapon(char code, PImage image, PVector ownerPosition, int maxShots, double fireDelay, double rechargeDelay, int damage) {
        super(0,0);
        this.code = (int) code;
        this.image = image;
        position = ownerPosition;
        this.maxShots = maxShots;
        this.currentShots = maxShots;
        this.fireDelay = fireDelay;
        this.rechargeDelay = rechargeDelay;
        this.damage = damage;
    }
    
    void refill() {
        this.currentShots = maxShots;
    }
    
    void tryToFire(int targetX, int targetY) {
        if (!((Robotron)currentScene).OptionsMenu.enabled && !((Robotron)currentScene).ShopMenu.enabled) {
            double current = millis();
            double elapsedSinceFired = current - lastFired;
            if (elapsedSinceFired > fireDelay * shopFireDelayMultiplier()) {
                if ((currentShots > 0 || maxShots == 0)) {
                    fire(targetX, targetY);
                    if (maxShots > 0 && !((Robotron)currentScene).OptionsMenu.infiniteAmmo.value) {
                        currentShots--;
                    }
                }
                else{
                    Audio.playWithProtection(Audio.noAmmo, 1f, Audio.audioPan(position.x), 0.3f);
                }
                lastFired = current;
            }   
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
                if (elapsedSinceRecharge > rechargeDelay * shopRechargeDelayMultiplier()) {
                    currentShots++;
                    lastRecharged = current;
                }
            }
        }
    }
    
    void render() {
        
    }
    
    protected abstract void fire(int targetX, int targetY);
    
    protected abstract float shopDamageMultiplier();
    protected abstract float shopRechargeDelayMultiplier();
    protected float shopFireDelayMultiplier() {
        return 1f;
    }
    
    @Override
    public int compareTo(Weapon other) {
        return Integer.compare(this.code, other.code);
    }
}
