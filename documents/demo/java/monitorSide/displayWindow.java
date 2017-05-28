import javax.swing.*;
import java.awt.*;
import java.io.*;
import java.awt.event.*;

public class displayWindow extends JFrame implements ActionListener{
    private int windowWidth = 1005; private int windowHeight = 548; 
    private pixelCanvas pixelCanvas_input = new pixelCanvas(100,100);
    private pixelCanvas pixelCanvas_output = new pixelCanvas(100,100);
    private JLabel keyText = new JLabel("0000000000000000"), spacerText_1 = new JLabel(" - "), spacerText_2 = new JLabel(" - "), modeText = new JLabel("encrypt");
    private JCheckBox checkBox = new JCheckBox("Slow Render Mode");

    private boolean slowRender = true;

	public displayWindow(){
		setSize(windowWidth, windowHeight);
		setLayout(new FlowLayout(FlowLayout.CENTER, 0, 0));
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setLocationRelativeTo(null);
		setResizable(false);

        add(pixelCanvas_input); add(pixelCanvas_output);
        keyText.setFont( new Font("Arial", Font.PLAIN, 20) );
        spacerText_1.setFont( new Font("Arial", Font.PLAIN, 20) );
        modeText.setFont( new Font("Arial", Font.PLAIN, 20) );
        spacerText_2.setFont( new Font("Arial", Font.PLAIN, 20) );
        checkBox.setFont( new Font("Arial", Font.PLAIN, 18) );
        checkBox.setSelected(true);
        checkBox.addActionListener(this);

        add(keyText);add(spacerText_1);add(modeText);add(spacerText_2);add(checkBox);
		
		setVisible(true);
    }

    public void actionPerformed(ActionEvent e) {
        slowRender = checkBox.isSelected();
    }

    public void update(filePackage incomingData){
        modeText.setText( incomingData.getMode() );
        keyText.setText( incomingData.getKey() );

        pixelCanvas_input.importPixels( incomingData.getInputPixels() ); 
        pixelCanvas_input.redraw();

        if(slowRender){ pixelCanvas_output.slow_importPixels( incomingData.getOutputPixels(), 1 ); }
        else{ pixelCanvas_output.importPixels( incomingData.getOutputPixels() ); pixelCanvas_output.redraw(); }
    }
}