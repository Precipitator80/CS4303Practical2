import java.util.List;

////////// Menus //////////

abstract class Menu extends UIItem {
    protected List<UIItem> menuItems;
    Button entryButton;
    Button exitButton;
    color fillColour;
    
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
    }
    
    abstract void initialise();
    
    void update() {
        
    }
    
    void render() {
        stroke(strokeColour);
        fill(fillColour);
        rectMode(CENTER);
        rect(position.x, position.y, w, h);
        super.render();
    }
    
    void show() {
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
    //public BoolButton hybridControlScheme;
    
    public OptionsMenu() {
        super("Options");
    }
    
    void initialise() {
        //hybridControlScheme = new BoolButton((int)position.x,(int)position.y, "Hybrid Bomb Explosion Order", true);
        //menuItems.add(hybridControlScheme);
    }
    
    void hide() {
        super.hide();
        // Enact changes here.
    }
}


class ShopMenu extends Menu {    
    int moneySpent;
    //ShopListing extraAmmo;
    
    public ShopMenu() {
        super("Shop");
    }
    
    void initialise() {
        //extraAmmo = new ShopListing((int) this.position.x,(int) this.position.y, "Extra Ammo", 100);
        //menuItems.add(extraAmmo);
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
        return 0; //return(int)(OptionsMenu.creditsMultiplier.value * levelManager.score / 10);
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
        if (ShopMenu.moneySpent + currentPrice < ShopMenu.totalMoneyEarned()) {
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
        return(3 * h) / 5;
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