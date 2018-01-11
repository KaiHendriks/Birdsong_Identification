Contains stuff required to install the MatConvNet CNN toolkit for Windows

Steps:
      1. Download all files within this folder
      2. Place the MatConvNet folder in a conveniant location (you will not be able to move it after installation or it will not work anymore)
      3. Install Visual Studio 2015 with the provided installer file (make sure to check the programming languages box upon install
      4. Once Visual Studio is installed, open Matlab
      5. Make sure Matlab has the folder where the MatConvNet folder is located open as a directory
      6. Run the following commands in order:
                cd MatConvNet
                addpath matlab
                vl_compilenn
                mex setup C++
      7. If there is no error and mex has sucessfully been installed, run the following command:
                run vl_setupnn
      8. This should install the toolkit, run the following command to check if it worked with a test run:
                vl_testnn
      9. SUCCESS, NOW PROFIT !
           