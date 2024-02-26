class ButtonManager {
    public final LinkedTransferQueue<Button> buttons = new LinkedTransferQueue<Button>();
    color defaultStrokeColour;
    color defaultFillColour;
    boolean pressedButton;
    boolean mouseDown;
    
    public ButtonManager(color defaultStrokeColour, color defaultFillColour) {
        this.defaultStrokeColour = defaultStrokeColour;
        this.defaultFillColour = defaultFillColour;
    }
    
    void mousePressed() {
        mouseDown = true;
    }
    
    void mouseReleased() {
        mouseDown = false;
        Iterator<Button> iterator = buttons.iterator();
        while(iterator.hasNext()) {
            Button button = iterator.next();
            if (button.enabled && button.mouseOver) {
                button.onClick();
                pressedButton = true;
            }
        }
    }
}

abstract class Button extends UIItem  {
    public boolean mouseOver;
    SoundFile clickSound;
    color strokeColour;
    color fillColour;
    
    public Button(int x, int y, String text, SoundFile clickSound) {
        this(x, y, text, clickSound, currentScene.BUTTON_MANAGER.defaultStrokeColour, currentScene.BUTTON_MANAGER.defaultFillColour);
    }
    
    public Button(int x, int y, String text, SoundFile clickSound, color strokeColour, color fillColour) {
        super(x,y,text);
        this.clickSound = clickSound;
        this.fillColour = fillColour;
        this.strokeColour = strokeColour;
        buttons().add(this);
    }
    
    void destroy() {
        super.destroy();
        buttons().remove(this);
    }
    
    void onClick() {
        clickSound.play(1, 0.2f);
    }
    
    void update() {
        if (mouseX >= position.x - w / 2  && mouseX <= position.x + w / 2 && 
            mouseY >= position.y - h / 2 && mouseY <= position.y + h / 2) {
            mouseOver = true;
        } else{
            mouseOver = false;
        }
    }
    
    void render() {
        stroke(strokeColour);
        fill(fillColour);
        rectMode(CENTER);
        rect(position.x, position.y, w, h);
        super.render();
    }
}

////////// Menu Navigation Buttons //////////

class EntryButton extends Button {
    Menu menu;
    public EntryButton(int x, int y, Menu menu) {
        super(x, y, menu.text, Audio.menuSelect);
        this.menu = menu;
    }
    
    void onClick() {
        super.onClick();
        menu.show();
    }
}

public class ExitButton extends Button {
    Menu menu;
    public ExitButton(int x, int y, Menu menu) {
        super(x, y, "Exit", Audio.menuBack);
        this.menu = menu;
    }
    
    void onClick() {
        super.onClick();
        menu.hide();
    }
}

////////// Special Buttons //////////

class ShopButton extends Button {
    ShopListing shopListing;
    boolean isBuyButton;
    public ShopButton(int x, int y, ShopListing shopListing, boolean isBuyButton) {
        super(x, y, isBuyButton ? "+" : "-", Audio.menuSelect);
        this.shopListing = shopListing;
        this.isBuyButton = isBuyButton;
    }
    
    void onClick() {
        // Play audio in shop listing instead.
        if (isBuyButton) {
            shopListing.buy();
        }
        else{
            shopListing.sell();
        }
    }
}

////////// Value Buttons //////////

class FloatButton extends Button {
    String optionName;
    float minValue;
    float maxValue;
    float value;
    float step;
    public FloatButton(int x, int y, String optionName, float initialValue, float minValue, float maxValue, float step) {
        super(x, y, optionName, Audio.menuSelect);
        this.optionName = optionName;
        this.minValue = minValue;
        this.maxValue = maxValue;
        this.step = step;
        value = initialValue;
    }
    
    void render() {
        text = optionName + ": " + value;
        super.render();
    }
    
    void onClick() {
        super.onClick();
        if (mouseButton == RIGHT) {
            value -= step;
            if (value < minValue) {
                value = maxValue;
            }
        }
        else{
            value += step;
            if (value > maxValue) {
                value = minValue;
            }
        }
    }
}

class IntButton extends Button {
    String optionName;
    int minValue;
    int maxValue;
    int value;
    public IntButton(int x, int y, String optionName, int initialValue, int minValue, int maxValue) {
        super(x, y, optionName, Audio.menuSelect);
        this.optionName = optionName;
        this.minValue = minValue;
        this.maxValue = maxValue;
        value = initialValue;
    }
    
    void render() {
        text = optionName + ": " + value;
        super.render();
    }
    
    void onClick() {
        super.onClick();
        if (mouseButton == RIGHT) {
            value--;
            if (value < minValue) {
                value = maxValue;
            }
        }
        else{
            value++;
            if (value > maxValue) {
                value = minValue;
            }
        }
    }
}

class BoolButton extends Button {
    String optionName;
    boolean value;
    public BoolButton(int x, int y, String optionName, boolean initialValue) {
        super(x, y, optionName, Audio.menuSelect);
        this.optionName = optionName;
        value = initialValue;
    }
    
    void render() {
        super.render();
        text = optionName + ": " + valueChar();
    }
    
    char valueChar() {
        return value ? '✓' : 'x';
    }
    
    void onClick() {
        super.onClick();
        value = !value;
    }
}
