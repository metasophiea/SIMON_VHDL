import java.io.Serializable;
import java.util.*;

public class filePackage implements Serializable{
    ArrayList<String> input_pixels, output_pixels = null; 
    String key = null; String mode = null;
    int imageWidth = 0; int imageHeight = 0;

    public filePackage(String mode, String key, int imageWidth, int imageHeight, ArrayList<String> input_pixels, ArrayList<String> output_pixels){
        this.mode = mode;
        this.key = key;
        this.imageWidth = imageWidth;
        this.imageHeight = imageHeight;
        this.input_pixels = input_pixels;
        this.output_pixels = output_pixels;
    }

    public String getMode(){return mode;}
    public String getKey(){return key;}
    public int getImageWidth(){return imageWidth;}
    public int getImageHeight(){return imageHeight;}
    public ArrayList<String> getInputPixels(){ return input_pixels; }
    public ArrayList<String> getOutputPixels(){ return output_pixels; }
}