public class Audio {
    PApplet mainClass;
    SoundFile menuBack;
    SoundFile menuSelect;
    SoundFile noAmmo;
    SoundFile powerUp;
    
    SoundFile pistol;
    SoundFile rifle;
    SoundFile pulseCannon;
    SoundFile railgun;
    SoundFile empCannon;
    SoundFile laserEnemy;
    
    
    Map<SoundFile, Boolean> played;
    
    public Audio(PApplet mainClass) {
        this.mainClass = mainClass;
        played = new HashMap<>();
        load();
    }
    
    void load() {
        menuBack = loadAudio("MenuBack.mp3");
        menuSelect = loadAudio("MenuSelect.mp3");
        noAmmo = loadAudio("NoAmmo.wav");
        powerUp = loadAudio("PowerUp.wav");
        
        pistol = loadAudio("Pistol.wav");
        rifle = loadAudio("Rifle.wav");
        pulseCannon = loadAudio("PulseCannon.wav");
        railgun = loadAudio("Railgun.wav");
        empCannon = loadAudio("EMPCannon.wav");
        laserEnemy = loadAudio("LaserEnemy.wav");
    }
    
    void playWithProtection(SoundFile sound, float rate, float pan, float volume) {
        if (!played.containsKey(sound)) {
            played.put(sound, false);
        }
        
        Boolean playedSound = played.get(sound);
        if (!playedSound) {
            sound.stop();
            sound.play(rate, pan, volume);
            playedSound = true;
        }
    }
    
    void playWithProtection(SoundFile sound, float rate, float volume) {
        if (!played.containsKey(sound)) {
            played.put(sound, false);
        }
        
        Boolean playedSound = played.get(sound);
        if (!playedSound) {
            sound.stop();
            sound.play(rate, volume);
            playedSound = true;
        }
    }
    
    void update() {
        for (Boolean playedSound : played.values()) {
            playedSound = false;
        }
    }
    
    SoundFile loadAudio(String fileName) {
        return new SoundFile(mainClass, fileName);
    }
    
    float audioPan(float xPos) {
        return(xPos - width / 2) / width;
    }
}