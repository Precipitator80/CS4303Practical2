public class DamageBoost extends StatusEffect {
    public DamageBoost(Player player, double duration) {
        super(player, duration, color(255,127,39));
    }
    
    void apply() {
        for (Weapon weapon : ((Player)character).weapons) {
            weapon.damageBoostMultiplier = 2;
        }
    }
    
    void unapply() {
        for (Weapon weapon : ((Player)character).weapons) {
            weapon.damageBoostMultiplier = 1;
        }
    }
}

public class SpeedBoost extends StatusEffect {
    float normalSpeed;
    
    public SpeedBoost(Character character, double duration) {
        super(character, duration, color(34,177,76));
    }
    
    void apply() {
        normalSpeed = character.movementSpeed;
        character.movementSpeed = normalSpeed * 2;
    }
    
    void unapply() {
        character.movementSpeed = normalSpeed;
    }
}

public class Freeze extends StatusEffect {
    boolean renderEffect;
    public Freeze(Character character, double duration, boolean renderEffect) {
        super(character, duration, color(0,162,232));
        this.renderEffect = renderEffect;
    }
    
    public Freeze(Character character, double duration) {
        this(character, duration, true);
    }
    
    void apply() {
        character.frozen = true;
    }
    
    void unapply() {
        character.frozen = false;
    }
    
    void render() {
        if (renderEffect) {
            super.render();
        }
    }
}

public class Highlight extends StatusEffect {
    public Highlight(Character character, double duration) {
        super(character, duration, color(0,0,160));
        size *= 3;
    }
    
    void apply() {}   
    void unapply() {}
}

public abstract class StatusEffect extends GameObject {
    Character character;
    double timeApplied;
    double duration;
    boolean applied;
    color tint;
    float size;
    
    public StatusEffect(Character character, double duration, color tint) {
        super(0,0);
        
        // Only apply if a status of this kind is not already applied.
        for (StatusEffect currentStatusEffect : character.statusEffects) {
            if (getClass().isInstance(currentStatusEffect)) {
                currentStatusEffect.timeApplied = millis();
                destroy();
                return;
            }
        }
        
        // Follow the character.
        this.character = character;
        this.position = character.position;
        
        // Apply the effect.
        apply();
        character.statusEffects.add(this);
        timeApplied = millis();
        applied = true;
        this.duration = duration * ((Robotron)currentScene).OptionsMenu.powerUpTimeMultiplier.value;
        this.tint = tint;
        this.size = character.size * 1.25f;
        
        Audio.playWithProtection(Audio.powerUp, 1f, Audio.audioPan(position.x), 0.3f);
    }
    
    void update() {
        if (millis() - timeApplied > duration) {
            destroy();
        }
    }
    
    void destroy() {
        if (applied) {
            unapply();
            character.statusEffects.remove(this);
        }
        super.destroy();
    }
    
    void render() {
        tint(tint, 150);
        image(Graphics.statusRing, position.x, position.y, size, size);
    }
    
    abstract void apply();
    abstract void unapply();
}