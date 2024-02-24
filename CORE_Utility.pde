class Utility{
    public PVector calculateStartingVelocity(int x, int y, int targetX, int targetY, float av) {
        PVector velocity = new PVector(0, 0);
        
        // Calculate the velocity based on projectile motion.
        //float av = gravity.gravity.y * OptionsMenu.gravityMultiplier.value; // Vertical acceleration.
        float sv = (y - targetY) / (float) height; // Vertical displacement.
        if (sv > 0) {        
            // Initial vertical speed.
            // v^2 =u^2 + 2aS
            // 0^2 =u^2 + 2aS
            // u = -sqrt(2aS)
            float uv= -sqrt(2 * av * sv);
            
            // Time until max height.
            // v = u+at
            // at =v - u
            // t = (v- u) / a
            // t = -u/ a
            float t= -uv / av; 
            
            // Initial horizontal speed.
            // d = vt
            // v = d/t       
            float uh = (targetX - x) / (t * width);
            
            // Define the velocity from its components.
            velocity.set(uh, uv);
        }
        else{
            // s = ut + (1/2)at^2
            // Given u =0:
            // s = (1/2)at^2
            // t^2 = 2s/a
            // t = sqrt(2s/a)
            float t = sqrt(abs(2 * sv / av));
            
            float uh = (targetX - x) / (t * width);
            
            velocity.set(uh, 0);
        }
        
        return velocity;
    }
    
    public int randomXOffsetWithinBounds(int previousX, float maxOffset) {
        return constrain(previousX + (int) random( -maxOffset * width, maxOffset * width), 0, width);
    }
    
    public void destroyIfOutOfBounds(GameObject gameObject, float size) {
        if (gameObject.position.x < 0 - size / 2) {
            gameObject.destroy();
        }   
        if (gameObject.position.x > width + size / 2) {
            gameObject.destroy();
        }
    }
}