import java.io.Serializable;
import java.util.*;

public class dataPackage implements Serializable{
    String local_command = null; // "latestPixel", "switch", "newInput"
    ArrayList<String> local_pixels = null; // for transporting lots of pixels
    String local_pixel = null; //the pixel data
    int local_pixelNumber = 0; //the pixel number

    public dataPackage(String command){ local_command = command; local_pixel = ""; }
    public dataPackage(String command, ArrayList<String> pixels){ local_command = command; local_pixels = pixels; }
    public dataPackage(String command, String pixel, int pixelNumber){
        local_command = command;
        local_pixel = pixel;
        local_pixelNumber = pixelNumber;
    }

    public String getCommand(){return local_command;}
    public String getPixel(){return local_pixel;}
    public int getPixelNumber(){return local_pixelNumber;}
    public ArrayList<String> getInputPixels(){ return local_pixels; }
}