import java.net.*;
import java.io.*;
import java.util.*;

public class connectionHandler extends Thread{
	private Socket clientSocket = null;	
	private ObjectOutputStream outputStream = null; private ObjectInputStream inputStream = null;

	public connectionHandler(Socket incomingSocket){
		System.out.println("operator_thread - connetion handler called");
		this.clientSocket = incomingSocket;
	}
    public void closeConnection(){
		try{ this.inputStream.close(); this.outputStream.close(); this.clientSocket.close(); }
		catch(IOException e){}
	}

	public void run(){
        //setup streams 
            System.out.println("setting up streams");
            System.out.println("operator_thread - setting up in/out streams");		
            try{
            this.inputStream = new ObjectInputStream(clientSocket.getInputStream());
            this.outputStream = new ObjectOutputStream(clientSocket.getOutputStream());
            System.out.println("operator_thread - Created in/out streams");
            }catch(IOException e){System.out.println("operator_thread - unable to create in/out streams");}

        //read processRequestPackage
            System.out.println("reading request");
            processRequestPackage incomingProcessRequestPackage = null;
            try{ incomingProcessRequestPackage = (processRequestPackage)inputStream.readObject(); }
            catch(Exception e){System.out.println("operator_thread - could not decode incomming package - bailing on connection"); this.closeConnection(); return;}
		
        //process
            //load mode and key into control file
                System.out.println("loading mode and key into control file");
                try{
                    BufferedWriter controlFile = new BufferedWriter(new FileWriter("../../files/control"));
                    System.out.println("key: " + incomingProcessRequestPackage.getKey() );
                    System.out.println("mode: " + incomingProcessRequestPackage.getMode() );
                    controlFile.write(incomingProcessRequestPackage.getKey()); 
                    controlFile.newLine();
                    controlFile.write(incomingProcessRequestPackage.getMode());
                    controlFile.close();
                }catch(IOException e){System.out.println("operator_thread - could not open control file for writing" + e);}  

            //load selected image into input file
                System.out.println("loading selected image '"+ incomingProcessRequestPackage.fileToProcess +"' into input file");
                ArrayList<String> inputImage = nextImage(incomingProcessRequestPackage.fileToProcess);

            //run c++ process
                System.out.println("running c++ program");
                try{
                    ProcessBuilder processBuilder = new ProcessBuilder("./a.out");
                    processBuilder.inheritIO();
                    processBuilder.directory(new File("../../c++/"));
                    Process process = processBuilder.start();
                    process.waitFor();
                }
                catch(Exception e){System.out.println("operator_thread - c++ process failed" + e);} 

            //load output image
                System.out.println("loading output image");
                ArrayList<String> outputImage = loadImageFile("output");

            //create filePackage
                System.out.println("creating package");
                filePackage outgoingFilePackage = new filePackage(incomingProcessRequestPackage.mode,incomingProcessRequestPackage.key,100,100,inputImage,outputImage);

            //send filePackage
                System.out.println("sending filePackage");
                sendData(outgoingFilePackage);

            //all done, go home
                System.out.println("process finished");
    }

    //returns image file data in ArrayList<String>
        static private ArrayList<String> loadImageFile(String imageFileName){
                ArrayList<String> data = new ArrayList<String>();

                    try{
                        BufferedReader bufferedReader = new BufferedReader(new FileReader("../../files/"+imageFileName));
                        String temp = null;
                        while( (temp = bufferedReader.readLine()) != null ){ data.add(temp); }
                        bufferedReader.close();
                    }catch(IOException e){System.out.println("operator_thread - could not open file for reading" + e);} 

                return data;
        }

    //fills input file with next image data, and returns same data in ArrayList<String>
        static private ArrayList<String> nextImage(String imageFile){
            ArrayList<String> newImage = new ArrayList<String>();

            //copy data into input file, filling newImage as we go
                try{
                    String temp = null;
                    BufferedReader bufferedReader_output = new BufferedReader(new FileReader("../../files/"+imageFile));
                    BufferedWriter bufferedWriter_input = new BufferedWriter(new FileWriter("../../files/input"));
                    temp = bufferedReader_output.readLine();
                    while( temp != null ){
                        newImage.add(temp);
                        bufferedWriter_input.write(temp);
                        if((temp = bufferedReader_output.readLine()) != null){ bufferedWriter_input.newLine(); }
                    }

                    bufferedReader_output.close();
                    bufferedWriter_input.close();
                }catch(IOException e){System.out.println("operator_thread - could not open image file for reading or input file for writing" + e);}  

            return newImage;
        }

    //standard object sending function
        private void sendData(Object o){
            try{outputStream.writeObject(o); outputStream.flush();}
            catch(Exception e){System.out.println("-- Error while sending data --");}
        }
}