import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.swing.JPanel;

public class pixelCanvas extends JPanel {
	private int windowWidth = 500, windowHeight = 500;
    private int pixelCount_x = 0, pixelCount_y = 0;
    private String[][] pixelArray = null;

    private int[] pixelNumberToXY(int pixelNumber){ pixelNumber = pixelNumber-1; return new int[]{ (pixelNumber/pixelCount_y) , (pixelNumber%pixelCount_x) }; }

	public pixelCanvas(int pixelCount_x, int pixelCount_y){
		setPreferredSize(new Dimension(windowWidth,windowHeight));	
        pixelArray = new String[pixelCount_y][pixelCount_x];
        this.pixelCount_x = pixelCount_x;
        this.pixelCount_y = pixelCount_y;
	}

    public void paint(Graphics g){
        //clear window
    		g.setColor(Color.white); g.fillRect(0,0,windowWidth,windowHeight+1);

        //background
            g.setColor(Color.decode("#eeeeee"));  g.fillRect(10, 10, windowWidth-20, windowHeight-20);

        //print pixles
            int pixelSize_x = windowWidth/pixelCount_x;
            int pixelSize_y = windowHeight/pixelCount_y;

            for(int y = 0; y < pixelArray.length; y++){
                for(int x = 0; x < pixelArray[0].length; x++){
                    if( pixelArray[y][x] != null ){
                        g.setColor(Color.decode( "#"+pixelArray[y][x].substring(0,6) ));  
                        g.fillRect(pixelSize_x*x, pixelSize_y*y, pixelSize_x, pixelSize_y);
                    }
                }
            }

    }

    public void redraw(){repaint();}
    public void updatePixel(int pixelNumber, String pixelValue){
        if(pixelValue == null){ return; }
        int[] XY = pixelNumberToXY(pixelNumber);
        pixelArray[XY[0]][XY[1]] = pixelValue;
        repaint();
    }

    public String[][] exportPixels(){ return pixelArray; }
    public void importPixels(String[][] pixels){ 
        for(int y = 0; y < pixels.length; y++){
            for(int x = 0; x < pixels[y].length; x++){
                pixelArray[y][x] = pixels[y][x];
            }
        }
    }
    public void clearPixels(){ pixelArray = new String[pixelCount_y][pixelCount_x]; }
}