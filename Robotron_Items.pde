abstract class Item extends GameObject {
    public Item(int x, int y) {
        super(x,y);
    }
    
    void update() {
        Player player = ((Robotron)currentScene).player;
        if (player.position.copy().sub(position).mag() < player.size / 2) {
            player.giveItem(this);
            destroy();
        }
    }
}

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
        
        new Laser((int)position.x,(int)position.y, shotVelocity, damage, true, shotColour);
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
        
        new Laser((int)position.x,(int)position.y, shotVelocity, damage, true, shotColour);
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

class Laser extends GameObject {
    PVector velocity;
    PVector renderOffset;
    final int damage;
    final boolean friendly;
    final color laserColour;
    
    public Laser(int x, int y, PVector velocity, int damage, boolean friendly, color laserColour) {
        super(x,y);
        this.velocity = velocity;
        this.renderOffset = velocity.copy().normalize().mult(0.01f * height);
        this.damage = damage;
        this.friendly = friendly;
        this.laserColour = laserColour;
    }
    
    void update() {
        position.add(velocity);
        if (((Robotron)currentScene).levelManager.insideOfWall((int)position.x,(int)position.y) || Utility.outOfBounds(this, renderOffset.mag() * 2)) {
            destroy();
        }
        else if (friendly) {
            Iterator<Enemy> iterator = ((Robotron)currentScene).ENEMIES.iterator();
            while(iterator.hasNext()) {
                Enemy enemy = iterator.next();
                if (touchingTarget(enemy)) {
                    enemy.damage(damage);
                    this.destroy();
                }
            }
        }
        else {
            Player player = ((Robotron)currentScene).player;
            if (touchingTarget(player)) {
                player.damage(damage);
                this.destroy();
            }
        }
    }
    
    boolean touchingTarget(Character target) {
        float radius = target.size / 2;
        return abs(target.position.x - position.x) < radius && abs(target.position.y - position.y) < radius;
    }
    
    void render() {
        strokeWeight(height / 150f);
        stroke(laserColour);
        line(position.x - renderOffset.x, position.y - renderOffset.y, position.x + renderOffset.x, position.y + renderOffset.y);
    }
}