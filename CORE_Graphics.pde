public class Graphics {    
    // Tiles and still enemies.
    PImage wall;
    PImage floor;
    PImage turretRobot;
    
    // Weapons
    PImage pistol;
    PImage rifle;
    PImage pulseCannon;
    PImage railgun;
    PImage empCannon;
    
    // Miscellaneous Items
    PImage statusRing;
    PImage freeze;
    PImage speedBoost;
    PImage damageBoost;
    
    // Health
    PImage health90;
    PImage health80;
    PImage health70;
    PImage health60;
    PImage health50;
    PImage health40;
    PImage health30;
    PImage health20;
    PImage health10;
    
    // Animators
    Animator playerAnimator;
    Animator gruntRobotAnimator;
    Animator laserRobotAnimator;
    Animator flyingRobotAnimator;
    Animator brainRobotAnimator;
    Animator wormRobotAnimator;
    Animator transformedHumanAnimator;
    Animator familyMember1Animator;
    
    // Other
    PImage crosshair;
    PFont robotronFont;
    
    public Graphics() {
        load();
    }
    
    void load() {
        try{
            // Tiles and still enemies.
            wall = loadImage("wall.png");
            floor = loadImage("floor.png");
            turretRobot = loadImage("turretRobot.png");
            
            // Weapons
            pistol = loadImage("pistol.png");
            rifle = loadImage("rifle.png");
            pulseCannon = loadImage("pulseCannon.png");
            railgun = loadImage("railgun.png");
            empCannon = loadImage("empCannon.png");
            
            // Miscellaneous Items
            statusRing = loadImage("statusRing.png");
            freeze = loadImage("freeze.png");
            speedBoost = loadImage("speedBoost.png");
            damageBoost = loadImage("damageBoost.png");
            
            // Health
            health90 = loadImage("HealthBar/health90.png");
            health80 = loadImage("HealthBar/health80.png");
            health70 = loadImage("HealthBar/health70.png");
            health60 = loadImage("HealthBar/health60.png");
            health50 = loadImage("HealthBar/health50.png");
            health40 = loadImage("HealthBar/health40.png");
            health30 = loadImage("HealthBar/health30.png");
            health20 = loadImage("HealthBar/health20.png");
            health10 = loadImage("HealthBar/health10.png");
            
            // Animators
            playerAnimator = new Animator("Player");
            gruntRobotAnimator = new Animator("GruntRobot");
            laserRobotAnimator = new Animator("LaserRobot");
            flyingRobotAnimator = new Animator("FlyingRobot", 0.3f, 1f);
            brainRobotAnimator = new Animator("BrainRobot");
            wormRobotAnimator = new Animator("WormRobot");
            transformedHumanAnimator = new Animator("TransformedHuman");
            familyMember1Animator = new Animator("FamilyMember1");
            
            // Other
            crosshair = loadImage("crosshair.png");
            robotronFont = createFont("robotron-2084.otf", 128);
            textFont(robotronFont);
        }
        catch(Exception e) {
            print(e.toString());
        }
    }
}