import java.io.Serializable;

public class dataPackage implements Serializable{
    String local_command = null; // "latestPixel" or "switch"
    String local_pixel = null; //the pixel data
    int local_pixelNumber = 0; //the pixel data

    public dataPackage(String command){ local_command = command; local_pixel = ""; }
    public dataPackage(String command, String pixel, int pixelNumber){
        local_command = command;
        local_pixel = pixel;
        local_pixelNumber = pixelNumber;
    }

    public String getCommand(){return local_command;}
    public String getPixel(){return local_pixel;}
    public int getPixelNumber(){return local_pixelNumber;}
}