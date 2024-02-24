import java.util.Iterator;

/**
* Holds all the force generators and the particles they apply to
*/
class ForceRegistry {
    
    /**
    *Keeps track of one force generator and the particle
    *it applies to.
    */
    class ForceRegistration {
        public final Particle particle;
        public final ForceGenerator forceGenerator;
        ForceRegistration(Particle p, ForceGenerator fg) {
            particle = p;
            forceGenerator = fg; 
        }
    }
    
    //Holds the list of registrations
    ArrayList<ForceRegistration> registrations = 
    new ArrayList();
    
    /**
    *Register the given force to apply to the given particle
    */
    void add(Particle p, ForceGenerator fg) {
        registrations.add(new ForceRegistration(p, fg)); 
    }
    
    /**
    *Remove the given registered pair from the registry. If the
    *pair isnot registered, this method will have no effect.
    */
    //This is going to be very inefficient with an AL. Suspect a
    //Hashmap with generator as key and value as list of particles
    //would be better.
    
    /**
    *Clear all registrations from the registry
    */
    void clear() {
        registrations.clear(); 
    }
    
    /**
    *Calls all force generators to update the forces of their
    *corresponding particles.
    */
    void updateForces() {
        Iterator<ForceRegistration> itr = registrations.iterator();
        while(itr.hasNext()) {
            ForceRegistration fr = itr.next();
            fr.forceGenerator.updateForce(fr.particle);
        }
    }
}


/*
* A force generator can be asked to add forces to
* one or more particles.
*/
abstract class ForceGenerator {
    void updateForce(Particle p) {
        p.addForce(calculateForce(p));
    }
    
    abstract PVector calculateForce(Particle p);
}


/**
* A force generator that applies a drag force.
* One instance can be used for multiple particles.
*/
public final class Drag extends ForceGenerator {
    //Velocity drag coefficient
    private float k1;
    //Velocity squared drag coefficient
    private float k2;
    
    //Construct generator with the given coefficients
    Drag(float k1, float k2) {
        this.k1 = k1;
        this.k2 = k2; 
    }
    
    //Applies the drag force to the given particle
    PVector calculateForce(Particle particle) {
        PVector force = particle.velocity.copy();
        
        //Calculate the total drag coefficient
        float dragCoeff = force.mag();
        dragCoeff = k1 * dragCoeff + k2 * dragCoeff * dragCoeff;
        
        //Calculate the final force and apply it
        force.normalize();
        force.mult( -dragCoeff);
        
        return force;
    }
}

/**
* A force generator that applies a gravitational force.
* One instance can be used for multiple particles.
*/
public final class Gravity extends ForceGenerator {
    
    //Holds the acceleration due to gravity
    private PVector gravity;
    
    //Constructs the generator with the given acceleration
    Gravity(PVector gravity) {
        this.gravity = gravity;
    }
    
    //This assumes the particle is small, with constant mass,
    //and gravity is being exerted on it by something relatively
    //massive.
    PVector calculateForce(Particle particle) {
        //should check for infinite mass
        //apply mass-scaled force to the particle
        PVector resultingForce = gravity.copy();
        resultingForce.mult(particle.getMass());
        return resultingForce;
    }
}
