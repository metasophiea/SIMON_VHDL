import java.io.Serializable;
import java.util.*;

public class processRequestPackage implements Serializable{
    String mode = null;
    String key = null;
    String fileToProcess = null;

    public processRequestPackage(String mode, String key, String fileToProcess){
        this.mode = mode;
        this.key = key;
        this.fileToProcess = fileToProcess;
    }

    public String getMode(){ return mode; }
    public String getKey(){ return key; }
    public String getFileToProcess(){ return fileToProcess; }
}