import java.net.*;
import java.io.*;
import java.util.*;

public class operator {
	private static int portNumber = 5050;
    private Socket socket = null;
    private ObjectOutputStream outputStream = null; private ObjectInputStream inputStream = null;
    private boolean flag = false;

	public static void main(String args[]){
		System.out.println("Java Operator Started");
		if(args.length == 2){
			operator subOperator = new operator(args[0]); 
			while(true){
				subOperator.process();
				try{Thread.sleep((long)(Float.parseFloat(args[1])*1000));}catch(InterruptedException e){}
			}
		}
		else{System.out.println("need address and time interval");}
		return;
	}

	public operator(String serverIP){ 
		try{
			this.socket = new Socket(serverIP,portNumber);
    		this.outputStream = new ObjectOutputStream(this.socket.getOutputStream());
    		this.inputStream = new ObjectInputStream(this.socket.getInputStream());
		}
		catch(Exception e){return;}
		return;
	}

    private void process(){
        dataPackage outgoingDataPackage = null;

        //run exe
            try{
                ProcessBuilder processBuilder = new ProcessBuilder("./a.out");
                processBuilder.inheritIO();
                processBuilder.directory(new File("../../c++/"));
                Process process = processBuilder.start();
                process.waitFor();
            }
            catch(Exception e){System.out.println(e);}

        //gather latest pixel
            int outputFileLength = 0; 
            String temp = null, lastLine = null;
            try{
                BufferedReader bufferedReader = new BufferedReader(new FileReader("../../files/output"));
                while( (temp = bufferedReader.readLine()) != null ){ outputFileLength++; lastLine = temp; }
                bufferedReader.close();
            }catch(Exception e){System.out.println(e);}

        //if no new pixels were added this time, push output into input, clear output, switch mode and send command to do switch
            //gather length of input file
                int inputFileLength = 0;
                try{
                    BufferedReader bufferedReader = new BufferedReader(new FileReader("../../files/input"));
                    while( (temp = bufferedReader.readLine()) != null ){ inputFileLength++;  }
                    bufferedReader.close();
                }catch(Exception e){System.out.println(e);}
            
            //if input and output files are the same length and flag is rasied; push output into input, clear output, switch mode, lower flag and send command to do switch. Otherwise send new pixel
                if(inputFileLength == outputFileLength && flag){
                    //overwrite input file
                        try{
                            BufferedReader bufferedReader_output = new BufferedReader(new FileReader("../../files/output"));
                            BufferedWriter bufferedWriter_input = new BufferedWriter(new FileWriter("../../files/input"));
                            temp = bufferedReader_output.readLine();
                            while( temp != null ){ 
                                bufferedWriter_input.write(temp);
                                if((temp = bufferedReader_output.readLine()) != null){ bufferedWriter_input.newLine(); }
                            }

                            bufferedReader_output.close();
                            bufferedWriter_input.close();
                        }catch(Exception e){System.out.println(e);}
                    //clear output file
                        try{
                            BufferedWriter bufferedWriter = new BufferedWriter(new FileWriter("../../files/output"));
                            bufferedWriter.close();
                        }catch(Exception e){System.out.println(e);}  
                    //switch mode
                        try{
                            BufferedReader bufferedReader = new BufferedReader(new FileReader("../../files/control"));
                            String key = bufferedReader.readLine();
                            String mode = bufferedReader.readLine();
                            bufferedReader.close();

                            if(mode.equals("encrypt")){mode = "decrypt";}else{mode = "encrypt";}

                            BufferedWriter bufferedWriter = new BufferedWriter(new FileWriter("../../files/control"));
                            bufferedWriter.write(key); bufferedWriter.newLine();
                            bufferedWriter.write(mode);
                            bufferedWriter.close();
                        }catch(Exception e){System.out.println(e);}
                    //lower flag
                        flag = false;
                    //load up command
                        outgoingDataPackage = new dataPackage("switch");
                }
            //if just input and output files are the same length, raise flag
                else if( inputFileLength == outputFileLength ){ flag = true; outgoingDataPackage = new dataPackage("latestPixel",lastLine,outputFileLength); }
            //load up new pixel
                else{ outgoingDataPackage = new dataPackage("latestPixel",lastLine,outputFileLength); }

        this.sendData(outgoingDataPackage);
    }

	private void sendData(Object o){ 
		try{outputStream.writeObject(o); outputStream.flush();}
		catch(Exception e){System.out.println("-- Error while sending data --");}
	}
}