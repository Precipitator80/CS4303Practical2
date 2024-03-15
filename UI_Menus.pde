import java.util.List;

////////// Menus //////////

abstract class Menu extends UIItem {
    protected List<UIItem> menuItems;
    Button entryButton;
    Button exitButton;
    color fillColour;
    float strokeWeight;
    
    public Menu(String name) {
        this(name,(4 * width) / 5,height / 10);
    }
    
    public Menu(String name, int entryButtonX, int entryButtonY) {
        this(name, entryButtonX, entryButtonY, currentScene.BUTTON_MANAGER.defaultStrokeColour, currentScene.BUTTON_MANAGER.defaultFillColour);
    }
    
    public Menu(String name, int entryButtonX, int entryButtonY, color strokeColour, color fillColour) {
        super(width / 2, height / 2,(3 * width) / 4,(3 * height) / 4, name, strokeColour);
        entryButton = new EntryButton(entryButtonX, entryButtonY, this);
        exitButton = new ExitButton((int)position.x,(int)position.y, this);
        this.fillColour = fillColour;
        this.strokeWeight = height / 150f;
        
        // Initialise menu items.
        menuItems = new ArrayList<UIItem>();
        initialise();
        menuItems.add(exitButton);
        
        // Place menu items.
        int itemWidth = (19 * w) / 20;
        int itemHeight = h / (menuItems.size() + 2); // Make space for the menu title (+1) and some padding between each item (+1).
        textSize = exitButton.defaultTextSize();
        textYOffset = -h / 2 + itemHeight / 2;
        // Place each item offset from the top of the menu by its index, using its height plus extra padding.
        for (int i = 0; i < menuItems.size();i++) {
            menuItems.get(i).place((int)position.x,(int)position.y + textYOffset + (i + 1) * (itemHeight + itemHeight / (menuItems.size() + 1)), itemWidth, itemHeight, textSize);
        }
        
        // Hide everything to start.
        hide();
        entryButton.hide();
    }
    
    abstract void initialise();
    
    void update() {
        
    }
    
    void render() {
        strokeWeight(strokeWeight);
        stroke(strokeColour);
        fill(fillColour);
        rectMode(CENTER);
        rect(position.x, position.y, w, h);
        super.render();
    }
    
    void show() {
       ((Robotron)currentScene).levelManager.clearLevel();
        super.show();
        exitButton.show();
        entryButton.hide();
        for (UIItem menuItem : menuItems) {
            menuItem.show();
        }
    }
    
    void hide() {
        super.hide();
        exitButton.hide();
        entryButton.show();
        for (UIItem menuItem : menuItems) {
            menuItem.hide();
        }
    }
}

class OptionsMenu extends Menu {
    public BoolButton allWeaponsAtStart;
    public BoolButton infiniteAmmo;
    public FloatButton creditsMultiplier;
    public FloatButton playerWeaponDamageMultiplier;
    public FloatButton playerSpeedMultiplier;
    public FloatButton powerUpTimeMultiplier;
    public FloatButton enemySpawnCountMultiplier;
    public FloatButton enemyMeleeDamageMultiplier;
    public FloatButton enemyLaserDamageMultiplier;
    public FloatButton enemySpeedMultiplier;
    
    public OptionsMenu() {
        super("Options");
    }
    
    void initialise() {
        allWeaponsAtStart = new BoolButton((int)position.x,(int)position.y, "All Weapons At Start", false);
        menuItems.add(allWeaponsAtStart);
        
        infiniteAmmo = new BoolButton((int)position.x,(int)position.y, "Infinite Ammo", false);
        menuItems.add(infiniteAmmo);
        
        creditsMultiplier = new FloatButton((int)position.x,(int)position.y, "Credits Multiplier", 1f, 0f, 10f, 0.5f);
        menuItems.add(creditsMultiplier);
        
        playerWeaponDamageMultiplier = new FloatButton((int)position.x,(int)position.y, "Player Weapon Damage Multiplier", 1f, 0.25f, 10f, 0.25f);
        menuItems.add(playerWeaponDamageMultiplier);
        
        powerUpTimeMultiplier = new FloatButton((int)position.x,(int)position.y, "Power-Up Time Multiplier", 1f, 0.25f, 10f, 0.25f);
        menuItems.add(powerUpTimeMultiplier);
        
        playerSpeedMultiplier = new FloatButton((int)position.x,(int)position.y, "Player Movement Speed Multiplier", 1f, 0.25f, 10f, 0.25f);
        menuItems.add(playerSpeedMultiplier);
        
        enemySpawnCountMultiplier = new FloatButton((int)position.x,(int)position.y, "Enemy Spawn Count Multiplier", 1f, 0.25f, 10f, 0.25f);
        menuItems.add(enemySpawnCountMultiplier);
        
        enemyMeleeDamageMultiplier = new FloatButton((int)position.x,(int)position.y, "Enemy Melee Damage Multiplier", 1f, 0f, 10f, 0.25f);
        menuItems.add(enemyMeleeDamageMultiplier);
        
        enemyLaserDamageMultiplier = new FloatButton((int)position.x,(int)position.y, "Enemy Laser Damage Multiplier", 1f, 0f, 10f, 0.25f);
        menuItems.add(enemyLaserDamageMultiplier);
        
        enemySpeedMultiplier = new FloatButton((int)position.x,(int)position.y, "Enemy Movement Speed Multiplier", 1f, 0f, 10f, 0.25f);
        menuItems.add(enemySpeedMultiplier);
    }
    
    void hide() {
        super.hide();
        // Enact changes here.
    }
}


class ShopMenu extends Menu {    
    int moneySpent;
    
    ShopListing pistolDamageIncrease;
    
    ShopListing rifleDamageIncrease;
    ShopListing rifleRechargeRateIncrease;
    ShopListing rifleFireRateIncrease;
    
    ShopListing pulseCannonDamageIncrease;
    ShopListing pulseCannonRechargeRateIncrease;
    ShopListing pulseCannonBurstCountIncrease;
    
    ShopListing railgunDamageIncrease;
    ShopListing railgunRechargeRateIncrease;
    ShopListing railgunBeamWidthIncrease;
    
    ShopListing empCannonDamageIncrease;
    ShopListing empCannonRechargeRateIncrease;
    ShopListing empCannonExplosionBurstIncrease;
    
    public ShopMenu() {
        super("Shop");
    }
    
    void initialise() {
        pistolDamageIncrease = new ShopListing((int) this.position.x,(int) this.position.y, "Pistol Damage Increase", 75, this);
        menuItems.add(pistolDamageIncrease);
        
        rifleDamageIncrease = new ShopListing((int) this.position.x,(int) this.position.y, "Rifle Damage Increase", 75, this);
        menuItems.add(rifleDamageIncrease);
        rifleRechargeRateIncrease = new ShopListing((int) this.position.x,(int) this.position.y, "Rifle Recharge Rate Increase", 25, this);
        menuItems.add(rifleRechargeRateIncrease);
        rifleFireRateIncrease = new ShopListing((int) this.position.x,(int) this.position.y, "Rifle Fire Rate Increase", 25, this);
        menuItems.add(rifleFireRateIncrease);
        
        pulseCannonDamageIncrease = new ShopListing((int) this.position.x,(int) this.position.y, "Pulse Cannon Damage Increase", 75, this);
        menuItems.add(pulseCannonDamageIncrease);
        pulseCannonRechargeRateIncrease = new ShopListing((int) this.position.x,(int) this.position.y, "Pulse Cannon Recharge Rate Increase", 25, this);
        menuItems.add(pulseCannonRechargeRateIncrease);
        pulseCannonBurstCountIncrease = new ShopListing((int) this.position.x,(int) this.position.y, "Pulse Cannon Burst Count Increase", 50, this);
        menuItems.add(pulseCannonBurstCountIncrease);
        
        
        railgunDamageIncrease = new ShopListing((int) this.position.x,(int) this.position.y, "Railgun Damage Increase", 75, this);
        menuItems.add(railgunDamageIncrease);
        railgunRechargeRateIncrease = new ShopListing((int) this.position.x,(int) this.position.y, "Railgun Recharge Rate Increase", 25, this);
        menuItems.add(railgunRechargeRateIncrease);
        railgunBeamWidthIncrease = new ShopListing((int) this.position.x,(int) this.position.y, "Railgun Beam Width Increase", 100, this);
        menuItems.add(railgunBeamWidthIncrease);
        
        empCannonDamageIncrease = new ShopListing((int) this.position.x,(int) this.position.y, "EMP Cannon Damage Increase", 75, this);
        menuItems.add(empCannonDamageIncrease);
        empCannonRechargeRateIncrease = new ShopListing((int) this.position.x,(int) this.position.y, "EMP Cannon Recharge Rate Increase", 25, this);
        menuItems.add(empCannonRechargeRateIncrease);
        empCannonExplosionBurstIncrease = new ShopListing((int) this.position.x,(int) this.position.y, "EMP Cannon Explosion Burst Increase", 50, this);
        menuItems.add(empCannonExplosionBurstIncrease);
        
    }
    
    void resetListings() {
        moneySpent = 0;
        for (UIItem menuItem : menuItems) {
            if (menuItem instanceof ShopListing) {
               ((ShopListing)menuItem).reset();
            }
        }
    }
    
    int totalMoneyEarned() {
        return(int)(((Robotron)currentScene).OptionsMenu.creditsMultiplier.value * ((Robotron)currentScene).levelManager.score / 100);
    }
    
    int moneyAvailable() {
        return totalMoneyEarned() - moneySpent;
    }
    
    void render() {
        extraText = " (Credits: " + moneyAvailable() + ")";
        super.render();
    }
}

class ShopListing extends UIItem {
    int basePrice;
    int timesBought;
    int currentPrice;
    
    ShopButton buyButton;
    ShopButton sellButton;
    
    ShopMenu ShopMenu;
    
    public ShopListing(int x, int y, String text, int basePrice, ShopMenu ShopMenu) {
        super(x,y,text);
        buyButton = new ShopButton(x + w, y, this, true);
        sellButton = new ShopButton(x - w, y, this, false);
        this.basePrice = basePrice;
        this.ShopMenu = ShopMenu;
        reset();
    }
    
    void update() {
        
    }
    
    void render() {
        extraText = " (Bought:  " + timesBought + ". Price: " + currentPrice + ")";
        super.render();
    }
    
    void buy() {
        if (ShopMenu.moneySpent + currentPrice <= ShopMenu.totalMoneyEarned()) {
            ShopMenu.moneySpent += currentPrice;
            timesBought++;
            updateCurrentPrice();
            Audio.menuSelect.play(1, 0.2f);
        }
        else{
            Audio.noAmmo.play(1, 0.3f);
        }
    }
    
    void sell() {
        if (timesBought > 0) {
            timesBought--;
            updateCurrentPrice();
            ShopMenu.moneySpent -= currentPrice;
            Audio.menuSelect.play(1, 0.2f);
        }
        else{
            Audio.noAmmo.play(1, 0.3f);
        }
    }
    
    void updateCurrentPrice() {
        currentPrice = roundUp(basePrice + basePrice / 2 * timesBought, 5);
    }
    
    // Rounding Up To The Nearest Hundred - rgettman - https://stackoverflow.com/questions/18407634/rounding-up-to-the-nearest-hundred - Accessed 11.02.2024
    int roundUp(int numberToRound, int numberToRoundTo) {
        return((numberToRound + numberToRoundTo - 1) / numberToRoundTo) * numberToRoundTo;
    }
    
    void reset() {
        timesBought = 0;
        currentPrice = basePrice;
    }
    
    void place(int x, int y, int w, int h, int textSize) {
        super.place(x, y,(4 * w) / 5, h, 3 * textSize / 4);
        buyButton.place(x + (9 * w) / 20, y, w / 10, h, textSize);
        sellButton.place(x - (9 * w) / 20, y, w / 10, h, textSize);
    }
    
    void show() {
        super.show();
        buyButton.show();
        sellButton.show();
    }
    
    void hide() {
        super.hide();
        buyButton.hide();
        sellButton.hide();
    }
}

////////// Core UIItem //////////

abstract class UIItem extends GameObject {
    protected String text;
    protected String extraText;
    protected int textSize;
    protected int textXOffset;
    protected int textYOffset;
    protected int w;
    protected int h;
    color strokeColour;
    
    public UIItem(int x, int y, String text) {
        this(x, y, text.length() * width / 40, height / 10, text, currentScene.BUTTON_MANAGER.defaultStrokeColour);
    }
    
    public UIItem(int x, int y, String text, color strokeColour) {
        this(x, y, text.length() * width / 40, height / 10, text, strokeColour);
    }
    
    public UIItem(int x, int y, int w, int h, String text, color strokeColour) {
        super(x,y);
        this.w = w;
        this.h = h;
        this.text = text;
        this.extraText = "";
        this.textSize = defaultTextSize();
        this.strokeColour = strokeColour;
    }
    
    void place(int x, int y, int w, int h) {
        place(x,y,w,h,defaultTextSize());
    }
    
    void place(int x, int y, int w, int h, int textSize) {
        position.x = x;
        position.y = y;
        this.w = w;
        this.h = h;
        this.textSize = textSize;
    }
    
    int defaultTextSize() {
        return h / 3;
    }
    
    void render() {
        fill(strokeColour);
        textAlign(CENTER, CENTER);
        textSize(textSize);
        text(text + extraText, position.x + textXOffset, position.y + textYOffset);
    }
    
    void show() {
        enabled = true;
    }
    
    void hide() {
        enabled = false;
    }
}