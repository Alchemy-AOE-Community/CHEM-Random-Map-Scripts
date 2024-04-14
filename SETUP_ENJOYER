Important Note:

The process described below is intended for "enjoyers" -- people who want a simple way to automatically download some or all of the Alchemy AOE Community's random map repository to a folder recognized by the game, without the need for creating an account. If you are a map creator and want to share content, consult the SETUP_COLLABORATOR readme file instead. 

_______________________________________________________________________________

Download Git Bash For Windows:

In order to automate the download of files, it is necessary to install Git Bash for Windows. 

Although the setup seems complicated, it is not possible to configure anything that would cause subsequent instruction not to work, and most importantly -- no account is required! 

Go here to download: https://gitforwindows.org/ and click on the download button! Give the download what it needs. 

After download is complete, launch Git Bash and continue through the next steps. 

_______________________________________________________________________________

Download Automation:

1) With Git Bash Open, type ``pwd`` to print working directory. Note that Git Bash has a slightly different way of displaying links -- it does not use ":" after drive letter, and places a "/" in front. The working directory is an important consideration, because Git Bash will write or operate on files only in this directory. 

2) It is very unlikely that the working directory summoned with the "pwd" command will coincide with the directory for random map scripts, but this can be changed. Identify the directory where random map scripts are stored on your computer, and paste the link to that folder inside of the following command: ``cd "LINK_TO_YOUR_RANDOM_MAP_FOLDER"``. 

    For example, the link for most random map folders is: "C:\Program Files (x86)\Steam\steamapps\common\AoE2DE\resources\_common\random-map-scripts" and the command to set working directory would be: ``cd "C:\Program Files (x86)\Steam\steamapps\common\AoE2DE\resources\_common\random-map-scripts"``

    After this command is run, Git Bash will respond with a highlighted link, confirming the new directory. Alternatively, you can type ``pwd`` again to see if the working directory has changed from what was seen in step (1). 

3) Make sure that the conflicting folder is not in this location by running the following command: ``rm -rf Alchemy-AOE-Community-Random-Map-Scripts``. This will send the obsolete directory and everything in it to the recycling bin. After repeating this process a few times, you may become creative in setting working directories as subfolders of the link in step (2), such that different parts of the map respository may be stored on your computer in different places, organized to your preferences.

4) Clone a specific branch of the Alchemy AOE Community Random Map Script repository using the following command, but substituting in the name of the branch you want where you see "DESIRED_BRANCH": ``git clone -b DESIRED_BRANCH --single-branch https://github.com/TechnicalChariot/Alchemy-AOE-Community-Random-Map-Scripts.git``. 

    For example, to download the contents of the "empty branch", the command would be: ``git clone -b _Empty_ --single-branch https://github.com/TechnicalChariot/Alchemy-AOE-Community-Random-Map-Scripts.git``.

    To obtain a list of eligible branches, you can visit the following website: "https://github.com/TechnicalChariot/Alchemy-AOE-Community-Random-Map-Scripts/branches/all". Note that there are probably only two types of branch that you would want: 
        1. The entire library (for variety in casual play), OR
        2. A branch for a specific competition hosted by the Alchemy AOE Community.  

    Once the command from this step is run, a folder called "Alchemy-AOE-Community-Random-Map-Scripts" will appear inside your directory for random maps. The game will detect any .rms files in this folder or subfolders, and you can select them in the scenario editor or lobby.

5) To update the files in this folder, repeat steps 2-4. Be sure to empty the recycle bin often if you are updating often!

6) To clear command history, enter: ``clear``. 
