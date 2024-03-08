public class Audio {
    PApplet mainClass;
    SoundFile menuBack;
    SoundFile menuSelect;
    SoundFile noAmmo;
    
    public Audio(PApplet mainClass) {
        this.mainClass = mainClass;
        load();
    }
    
    void load() {
        menuBack = loadAudio("MenuBack.mp3");
        menuSelect = loadAudio("MenuSelect.mp3");
        noAmmo = loadAudio("NoAmmo.wav");
    }
    
    SoundFile loadAudio(String fileName) {
        return new SoundFile(mainClass, fileName);
    }
    
    float audioPan(float xPos) {
        return(xPos - width / 2) / width;
    }
}