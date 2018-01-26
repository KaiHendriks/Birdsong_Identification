import jdk.nashorn.internal.scripts.JO;

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
            this.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
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
    //recursion for having proper digits
    public static String zeros (String n) {

        if (n.length()== 4) return n;
        else{
            n = "0"+n;
        }
        return zeros(n);
    }


    public static void main(String[] args) {
        String TXTFILE = null;
        String TXTFILE2 = null;
        String CNTFILE = null;
        String Filename = null;
        Boolean again = true;
        String NameOfFile;
        String species = "NA";
        while (again) {  //Loop allows for multiple folders to be looked one after another


            //Initial prompt that requires input of the folder path
            String directoryPath = JOptionPane.showInputDialog(null, "Here, you will choose whether the picture is a phoneme. Please input the file directory", "");
            species = JOptionPane.showInputDialog(null, "Species name:");
            if (directoryPath == null) {
                System.exit(0);
            }

            File spectro = new File(directoryPath);
            File[] files1 = spectro.listFiles(); //This loop will find the text file and assign the name to TXTFILE for later use
            for (int i = 0; i < files1.length; i++) {
                NameOfFile = files1[i].getName();
                if (NameOfFile.contains("phonemes.txt")) {
                    Filename = NameOfFile;
                    TXTFILE2 = directoryPath +"\\"+NameOfFile.substring(0,NameOfFile.length()-12)+"specie.txt";
                    System.out.println(TXTFILE2);
                    TXTFILE = directoryPath + "\\" + NameOfFile;
                    CNTFILE = directoryPath + "\\ Accuracy.txt";
                }
            }
            // Create a Phoneme counter
            File count = new File(CNTFILE);
            try {
                PrintWriter cw = new PrintWriter(count);
                cw.println("Total Phonemes     : 0000");
                cw.println("Correct Phonemes   : 0000");
                cw.println("Incorrect Phonemes : 0000");
                cw.println("Multiple Phonemes  : 0000");
                cw.close();
            }catch (Exception e) {
                e.printStackTrace();
            }

            File log = new File(TXTFILE);


            //Phoneme recognition part

            File path = new File(directoryPath);
            File[] files = path.listFiles();

            for (int i = 0; i < files.length; i++) {



                NameOfFile = files[i].getName();

                //prevents taking spectrogram and other types of files
                if (((!NameOfFile.contains("spectrogram")) && !NameOfFile.contains("Accuracy") && !NameOfFile.contains(".txt")) && NameOfFile.contains(".png")) {

                    //this will take the phoneme number
                    String number = NameOfFile.substring(NameOfFile.length() - 8, NameOfFile.length() - 4);


                    //Search parameters for later search and replacement in text file
                    String search = "phoneme " + number;

                    String replacement = "background";




                    //Makes phoneme visible
                    PictureInFrame picture = new PictureInFrame(files[i].toString());
                    picture.setVisible(true);


                    //This asks to user to choose whether the picture shown is a phoneme
                    int isPhoneme = JOptionPane.showConfirmDialog(null, "Is this a phoneme?",
                            files[i].getName(), JOptionPane.YES_NO_CANCEL_OPTION);
                    UIManager.put("OptionPane.cancelButtonText", "Multiple");
                    String s = null, putdata = null;

                    if (isPhoneme == JOptionPane.CLOSED_OPTION) {
                        System.exit(0);
                    }




                    if (isPhoneme == 1) {
                        try {
                            FileReader cr = new FileReader(count);

                            String totalStr = "";
                            try (BufferedReader br = new BufferedReader(cr)) {

                                while ((s = br.readLine()) != null) {
                                    totalStr += (s + "\n");
                                }
                                String[] lines = totalStr.split("\n");
                                String tot = lines[0].substring(21, 25);
                                String cor = lines[2].substring(21, 25);
                                System.out.println(tot);
                                int foo = Integer.parseInt(tot) + 1;
                                int foo2 = Integer.parseInt(cor) + 1;
                                String tot1 = Integer.toString(foo);
                                tot1 = zeros(tot1);
                                String cor1 = Integer.toString(foo2);
                                cor1 = zeros(cor1);
                                lines[0] = lines[0].replaceAll(tot, tot1);
                                lines[2] = lines[2].replaceAll(cor, cor1);
                                PrintWriter fw = new PrintWriter(count);
                                for (int j = 0; j < lines.length; j++) {
                                    fw.println(lines[j]);
//                                        System.out.println(lines[j]);
                                }
                                fw.close();


                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }


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
                    if (isPhoneme == 0) {
                        try {
                            FileReader cr = new FileReader(count);

                            String totalStr = "";
                            try (BufferedReader br = new BufferedReader(cr)) {

                                while ((s = br.readLine()) != null) {
                                    totalStr += (s + "\n");
                                }
                                String[] lines = totalStr.split("\n");
                                String tot = lines[0].substring(21, 25);
                                String cor = lines[1].substring(21, 25);
                                System.out.println(tot);
                                int foo = Integer.parseInt(tot) + 1;
                                int foo2 = Integer.parseInt(cor) + 1;
                                String tot1 = Integer.toString(foo);
                                tot1 = zeros(tot1);
                                String cor1 = Integer.toString(foo2);
                                cor1 = zeros(cor1);
                                lines[0] = lines[0].replaceAll(tot, tot1);
                                lines[1] = lines[1].replaceAll(cor, cor1);
                                PrintWriter fw = new PrintWriter(count);
                                for (int j = 0; j < lines.length; j++) {
                                    fw.println(lines[j]);
//                                        System.out.println(lines[j]);
                                }
                                fw.close();


                            }
                            catch (Exception e) {
                                e.printStackTrace();
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }


                        String NameOfPhoneme = JOptionPane.showInputDialog(null,"Name of the phoneme: If doesn't exist, then add next letter.");

                        try{
                            File log2 = new File (TXTFILE);


                            FileReader cr = new FileReader(log);


                            String totalStr = "";
                            try (BufferedReader br = new BufferedReader( cr)) {

                                while ((s = br.readLine()) != null) {
                                    totalStr += (s + "\n");
                                }

                                String[] lines = totalStr.split("\n");
                                for (int j= 0;j<lines.length;j++){
                                    if (lines[j].contains(search)){
                                        if (species.contains(" ")){species = species.replaceAll(" ","-");}
                                        lines[j]=lines[j].substring(0,37)+ species+ "-phoneme-"+NameOfPhoneme.toUpperCase();
                                    }
                                }

                                PrintWriter fw = new PrintWriter(log2);
                                for (int j = 0; j < lines.length; j++) {
                                    fw.println(lines[j]);
                                }


                                fw.close();



                            }

                        }catch (Exception e) {
                            e.printStackTrace();

                        }


                    }
                    if (isPhoneme == 2) {
                        try {
                            FileReader cr = new FileReader(count);

                            String totalStr = "";
                            try (BufferedReader br = new BufferedReader(cr)) {

                                while ((s = br.readLine()) != null) {
                                    totalStr += (s + "\n");
                                }
                                String[] lines = totalStr.split("\n");
                                String tot = lines[0].substring(21, 25);
                                String cor = lines[3].substring(21, 25);
                                System.out.println(tot);
                                int foo = Integer.parseInt(tot) + 1;
                                int foo2 = Integer.parseInt(cor) + 1;
                                String tot1 = Integer.toString(foo);
                                tot1 = zeros(tot1);
                                String cor1 = Integer.toString(foo2);
                                cor1 = zeros(cor1);
                                lines[0] = lines[0].replaceAll(tot, tot1);
                                lines[3] = lines[3].replaceAll(cor, cor1);
                                PrintWriter fw = new PrintWriter(count);
                                for (int j = 0; j < lines.length; j++) {
                                    fw.println(lines[j]);
//                                        System.out.println(lines[j]);
                                }
                                fw.close();


                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }

                        try{
                            File log2 = new File (TXTFILE);


                            FileReader cr = new FileReader(log);


                            String totalStr = "";
                            try (BufferedReader br = new BufferedReader( cr)) {

                                while ((s = br.readLine()) != null) {
                                    totalStr += (s + "\n");
                                }

                                String[] lines = totalStr.split("\n");
                                for (int j= 0;j<lines.length;j++){
                                    if (lines[j].contains(search)){
                                        if (species.contains(" ")){species = species.replaceAll(" ","-");}
                                        lines[j]=lines[j].substring(0,37)+ species +"-unknown-phoneme";
                                    }
                                }

                                PrintWriter fw = new PrintWriter(log2);
                                for (int j = 0; j < lines.length; j++) {
                                    fw.println(lines[j]);
                                }


                                fw.close();



                            }

                        }catch (Exception e) {
                            e.printStackTrace();

                        }

                    }


                    picture.dispose();
                }

            }


            try{
                File log2 = new File (TXTFILE2);

                FileReader cr = new FileReader(log);
                String s;
                String totalStr = "";
                try (BufferedReader br = new BufferedReader( cr)) {


                    while ((s = br.readLine()) != null) {
                        totalStr += (s + "\n");
                    }
                    String[] lines = totalStr.split("\n");
                    for (int i= 0;i<lines.length;i++){
                        if (lines[i].contains(species)){
                            if (species.contains(" ")){species = species.replaceAll(" ","-");}
                            lines[i]=lines[i].substring(0,37)+ species;
                        }
                    }

                    PrintWriter fw = new PrintWriter(log2);
                    for (int j = 0; j < lines.length; j++) {
                        fw.println(lines[j]);
                    }
                    fw.close();

                }}catch (Exception e) {
                e.printStackTrace();
            }

            //This asks the user if he/she wants to continue with another folder
            int continueLoop = JOptionPane.showConfirmDialog(null, "Do you want to do another folder?", "Quit?", JOptionPane.YES_NO_OPTION);
            if (continueLoop == JOptionPane.NO_OPTION) {
                again = false;
            }



        }
    }

}