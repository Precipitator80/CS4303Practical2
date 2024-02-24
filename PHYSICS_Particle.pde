// a representation of a point mass
abstract class Particle extends GameObject {
    
    //Vectors to hold pos, vel
    //I'm allowing public access to keep things snappy.
    public PVector velocity;
    
    //Vector to accumulate forces prior to integration
    private PVector forceAccumulator = new PVector(0, 0); 
    
    //Store inverse mass to allow simulation of infinite mass
    public float invMass;
    
    // A size for any collisions and rendering.
    public float size;
    
    //If you do need the mass, here it is:
    public float getMass() {return 1 / invMass;}
    
    Particle(int x, int y, PVector velocity, float invMass, float size) {
        super(x, y);
        this.velocity = velocity;
        this.invMass = invMass;
        this.size = size;
        
        //forceRegistry.add(this, gravity);
        //forceRegistry.add(this, drag);
    }
    
    // Add a force to the accumulator.
    void addForce(PVector force) {
        forceAccumulator.add(force);
    }
    
    // Update motion.
    void integrate() {
        // If infinite mass, we don't integrate
        if (invMass <= 0f) return;
        
        // Update position - Normalise velocity over screen space and add the result to the position.
        PVector normalisedVelocity = new PVector(velocity.x * width, velocity.y * height);
        position.add(normalisedVelocity);
        
        // Update acceleration - Get the force applied and multiply it by the inverse mass to get acceleration.
        forceAccumulator.mult(invMass);
        
        // Update velocity - Add the acceleration to the current velocity value.
        velocity.add(forceAccumulator);
        
        // Clear the force accumulator.
        forceAccumulator.x = 0;
        forceAccumulator.y = 0;
    }
    
    void update() {
        integrate();
        
        // Destroy the particle if it goes out of bounds horizontally.
        Utility.destroyIfOutOfBounds(this, size);
    }
}
