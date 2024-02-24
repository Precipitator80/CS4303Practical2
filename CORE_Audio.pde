public class Audio {
    PApplet mainClass;
    String audioFolder = "Audio/";
    SoundFile menuBack;
    SoundFile menuSelect;
    SoundFile noAmmo;
    
    public Audio(PApplet mainClass) {
        this.mainClass = mainClass;
        load();
    }
    
    void load() {
        menuBack = loadAudioWithFolder("MenuBack.mp3");
        menuSelect = loadAudioWithFolder("MenuSelect.mp3");
        noAmmo = loadAudioWithFolder("NoAmmo.wav");
    }
    
    SoundFile loadAudioWithFolder(String fileName) {
        return new SoundFile(mainClass, audioFolder + fileName);
    }
    
    float audioPan(float xPos) {
        return(xPos - width / 2) / width;
    }
}