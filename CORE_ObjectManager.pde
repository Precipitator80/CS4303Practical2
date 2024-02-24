import java.util.concurrent.LinkedTransferQueue;

public abstract class Scene {
    public final ObjectManager OBJECT_MANAGER = new ObjectManager();
    public final ButtonManager BUTTON_MANAGER;
    
    public Scene(color defaultStrokeColour, color defaultFillColour) {
        BUTTON_MANAGER = new ButtonManager(defaultStrokeColour, defaultFillColour);
    }
    
    void update() {
        OBJECT_MANAGER.update();
    }
    
    void render() {
        OBJECT_MANAGER.render();
    }
    
    void mouseReleased() {
        BUTTON_MANAGER.mouseReleased();
    }
    
    abstract void keyPressed();
}

class ObjectManager {
    public final LinkedTransferQueue<GameObject> gameObjects = new LinkedTransferQueue<GameObject>();
    
    public void update() {
        // Update all GameObjects, removing any marked for destruction.
        Iterator<GameObject> iterator = gameObjects.iterator();
        while(iterator.hasNext()) {
            GameObject gameObject = iterator.next();
            if (gameObject.enabled) {
                gameObject.update();
            }
            if (gameObject.destroyed()) {
                iterator.remove();
            }
        }
    }
    
    public void render() {
        // Render all GameObjects.
        Iterator<GameObject> iterator = gameObjects.iterator();
        while(iterator.hasNext()) {
            GameObject gameObject = iterator.next();
            if (gameObject.enabled) {
                gameObject.render();
            }
        }
    }
}

abstract class GameObject {
    public PVector position;
    private boolean destroyed = false;
    protected boolean enabled;
    public GameObject(int x, int y) {
        this.position = new PVector(x,y);
        gameObjects().add(this);
    }
    
    public void destroy() {
        destroyed = true;
    }
    public boolean destroyed() {
        return destroyed;
    }
    
    abstract void update();
    abstract void render();
}