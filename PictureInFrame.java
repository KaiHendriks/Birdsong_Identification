//import jdk.nashorn.internal.scripts.JO;

import java.awt.*;
import java.io.*;

import javax.swing.*;
import javax.swing.JFrame;


@SuppressWarnings("serial")
public class PictureInFrame extends JFrame {

    public PictureInFrame(String argx) {
        if (argx == null) {     //If no files exist in the folder, exit
            System.exit(0);

        }

//        else if (argx.contains("spectrogram")){
//
//            Dimension dim = Toolkit.getDefaultToolkit().getScreenSize();
//
//
//            GridBagConstraints constraints = new GridBagConstraints();
//            this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
//
//            JPanel panel = new JPanel();
//            panel.setSize(500, 640);
//            panel.setBackground(Color.BLACK);
//            ImageIcon icon = new ImageIcon(argx);
//            JLabel label = new JLabel();
//            label.setIcon(icon);
//            panel.add(label);
//            this.getContentPane().add(panel);
//            panel.add(label);
//            constraints.anchor = GridBagConstraints.CENTER;
//            this.getContentPane().add(panel);
//            this.setLocation(dim.width / -12 - this.getSize().width / -7, dim.height / 8 - this.getSize().height / 7);
//            this.setSize(1000, 1000);
//
//            panel.setVisible(true);
//        }

        else {   //Sets the size and instructions for the phoneme picture frame that appears

            Dimension dim = Toolkit.getDefaultToolkit().getScreenSize();


            GridBagConstraints constraints = new GridBagConstraints();
            this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            this.setSize(500, 640);
            JPanel panel = new JPanel();
            panel.setSize(2000, 2000);
            panel.setBackground(Color.BLACK);
            ImageIcon icon = new ImageIcon(argx);
            JLabel label = new JLabel();
            label.setIcon(icon);
            panel.add(label);
            this.getContentPane().add(panel);
            panel.add(label);
            constraints.anchor = GridBagConstraints.CENTER;
            this.getContentPane().add(panel);
            this.setLocation(dim.width / 12 - this.getSize().width / 7, dim.height / 8 - this.getSize().height / 7);
            this.setSize(500, 500);

            panel.setVisible(true);

        }
    }


    public static void main(String[] args) {
        String TXTFILE = null;
        Boolean again = true;
        String NameOfFile;
        while (again) {  //Loop allows for multiple folders to be looked one after another


            //Initial prompt that requires input of the folder path
            String directoryPath = JOptionPane.showInputDialog(null, "Here, you will choose whether the picture is a phoneme. Please input the file directory", "");
            if (directoryPath == null) {
                System.exit(0);
            }

            File spectro = new File(directoryPath);
            File[] files1 = spectro.listFiles(); //This loop will find the text file and assign the name to TXTFILE for later use
            for (int i = 0; i < files1.length; i++) {
                NameOfFile = files1[i].getName();
                if (NameOfFile.contains(".txt")) {
                    TXTFILE = directoryPath + "\\" + NameOfFile;
                }
            }


            //Phoneme recognition part

            File path = new File(directoryPath);
            File[] files = path.listFiles();

            for (int i = 0; i < files.length; i++) {


                if (files[i].isFile()) { //this line weeds out other directories/folders
                    NameOfFile = files1[i].getName();

                    //prevents taking spectrogram and other types of files
                    if ((!NameOfFile.contains("spectrogram") && !NameOfFile.contains(".txt") || !NameOfFile.contains(".png"))) {

                        //this will take the phoneme number
                        String number = NameOfFile.substring(NameOfFile.length() - 8, NameOfFile.length() - 4);
                        File log = new File(TXTFILE);


                        //Search parameters for later search and replacement in text file
                        String search = "phoneme " + number;
                        
                        String replacement = "background";


                        //Makes phoneme visible
                        PictureInFrame picture = new PictureInFrame(files[i].toString());
                        picture.setVisible(true);


                        //This asks to user to choose whether the picture shown is a phoneme
                        int isPhoneme = JOptionPane.showConfirmDialog(null, "Is this a phoneme?",
                                files[i].getName(), JOptionPane.YES_NO_OPTION);
                        String s = null, putdata = null;

                        if (isPhoneme == JOptionPane.CLOSED_OPTION) {
                            System.exit(0);
                        }

                        if (isPhoneme == 1) {


//THis will override the text file in case the phoneme is a background noise
                            try {
                                FileReader fr = new FileReader(log);

                                String totalStr = "";
                                try (BufferedReader br = new BufferedReader(fr)) {

                                    while ((s = br.readLine()) != null) {
                                        totalStr += (s + "\n");
                                    }
                                    putdata = totalStr.replaceAll(search, replacement);

                                    String[] lines = putdata.split("\n");

                                    PrintWriter fw = new PrintWriter(log);
                                    for (int j = 0; j < lines.length; j++) {
                                        fw.println(lines[j]);
//                                        System.out.println(lines[j]);
                                    }
                                    fw.close();


                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            }


//THis will delet the file that is not a phoneme
                            try {


                                files[i].delete();


                                System.out.println(files[i].getName() + " is deleted!");


                            } catch (Exception e) {

                                e.printStackTrace();

                            }
                        }


                        picture.dispose();
                    }
                }
            }


            //This asks the user if he/she wants to continue with another folder
            int continueLoop = JOptionPane.showConfirmDialog(null, "Do you want to do another folder?", "Quit?", JOptionPane.YES_NO_OPTION);
            if (continueLoop == JOptionPane.NO_OPTION) {
                again = false;
            }

        }
    }
}
