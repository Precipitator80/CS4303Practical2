class FSM extends GameObject {
    State currentState;
    public FSM(PVector parent) {
        super((int) parent.x,(int) parent.y);
        position = parent;
    }
    
    void update() {
        
    }
    
    void render() {
        
    }
}

abstract class State {
    abstract void update();
    abstract void stateChanges();
}