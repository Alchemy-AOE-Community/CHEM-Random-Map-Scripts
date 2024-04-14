Important Note:

The instructions below are intended for collaborators -- people who wish to upload and share their random map creations through this repository. If all you want to do is automate the download of files, then SETUP_ENJOYER (an alternate readme file) is recommended. 

_______________________________________________________________________________

Introduction:

Welcome to the AOE2:DE RMS Collaboration project! This repository is intended to be a comprehensive library of custom Random Map Scripts developed using the advanced techniques of the Alchemy AOE Community. Since it is based in GitHub, any scripts shared through the repository are monitored for changes, which is useful for code review and collaboration, but can involve additional responsibilities. To help us make sure that this repository is productive for everyone, please observe the process below to collaborate with us to create cutting-edge AOE2 random maps.

___________________________________________________________________________________________________________________________________________________________
How to Configure Github Repository on Your PC:

1) Create a free Github Account by going to the following website: https://github.com/, clicking on the button below and following the  prompts/instructions:
![image](https://user-images.githubusercontent.com/115369420/194990488-0ea840ee-bf04-4c92-a261-27658236f0cb.png)

2) Configure Github to your desktop by going to the following website: https://desktop.github.com/ and clicking on the button below:
![image](https://user-images.githubusercontent.com/115369420/194990520-1cbc95de-5c1d-4797-9a88-ccd5df84eebb.png)

3) Visit the working directory for AOE2 map scripts: C:\Program Files (x86)\Steam\steamapps\common\AoE2DE\resources\_common\random-map-scripts
In its unmodified state, this directory will contain the original Ensemble Studios map scripts:
![image](https://user-images.githubusercontent.com/115369420/194990628-ddad0474-db8e-466c-9363-1116ea14971a.png)
Move these scripts to their own subfolder or delete them:
![image](https://user-images.githubusercontent.com/115369420/194990722-2f4b7907-fb7f-4294-a4c0-cd83ba10518f.png)
This is necessary because if it is not done, an error will be thrown when attempting to clone the Github repository to this location:
![image](https://user-images.githubusercontent.com/115369420/194990782-6b77ae3d-06e7-48cf-9cd6-609fa173c44f.png)
At this time, you can create other folders in this location. For example, here is a directory configured with a “My_Workshop” folder that will not be monitored by Github. This is useful for private scripts/projects that you don’t want to share with the world: 
![image](https://user-images.githubusercontent.com/115369420/194990849-53918569-bc76-4286-aa11-2d7da6ecffb9.png)

4) Launch Github desktop and select the following “Clone Repository from the Internet”:
![image](https://user-images.githubusercontent.com/115369420/194990918-7d129d19-210f-44ab-84da-dec0d58a61a7.png)

5) Select URL tab (furthest right):
![image](https://user-images.githubusercontent.com/115369420/194991629-52762be0-5041-495f-934e-f9ff5f8d6bb2.png)
Type in the following URL: https://github.com/Alchemy-AOE-Community/Random-Map-Scripts-AOE2
Make sure that your Local path is set to: C:\Program Files (x86)\Steam\steamapps\common\AoE2DE\resources\_common\random-map-scripts 
Hit “Clone”:
![image](https://github.com/Alchemy-AOE-Community/Random-Map-Scripts-AOE2/assets/167009733/2473ba82-f4d0-42b6-bd1e-3715f229c16a)


6) A few loading screens will process, and when completed, you should be able to visit:  C:\Program Files (x86)\Steam\steamapps\common\AoE2DE\resources\_common\random-map-scripts and confirm that an additional folder called “Random-Map-Scripts-AOE2” has been added:
![image](https://user-images.githubusercontent.com/115369420/194993716-a83da5d6-69d8-49f6-80fc-866a374c8484.png)
Any folders or files you add to this folder will be tracked by Github and visible to any other collaborators of the repository. Happy scripting!




____________________________________________________________________________________________________________________________________________________________
How to Share Scripts on the Repository:

1) Launch Github Desktop by double clicking the following Icon:
![image](https://user-images.githubusercontent.com/115369420/196481287-b050a3ef-8d29-4599-a82a-6641ebc3a92e.png)

2) After the application has finished launching, click on "Current branch":
![image](https://user-images.githubusercontent.com/115369420/196481872-98d197ab-d06b-44d5-a4ea-562adca6e40f.png)

3) A drop down menu will appear, listing all of the "Branches" that have been worked on recently. Search for the branch called "Empty", and select it under "Recent branches":
![image](https://user-images.githubusercontent.com/115369420/196481769-3a6443de-b1e2-4209-9b2a-750d8eb1325e.png)

4) The application will think for a few seconds during which time it will display a "Switching to branch 'empty' ..." with a circular loading symbol. When done, it will appear as follows:
![image](https://user-images.githubusercontent.com/115369420/196482096-98d6bcbc-b10d-401d-9ce5-1222fb3a5b2d.png)
Note that the current branch is listed as "_ Empty _", and that there are no files in C:\Program Files (x86)\Steam\steamapps\common\AoE2DE\resources\_common\random-map-scripts\Random-Map-Scripts-AOE2, per the following image:
![image](https://user-images.githubusercontent.com/115369420/196483537-fbbc3760-01bd-482d-9bbe-2fd1b0c5ef79.png)

5) Hit crtl + shift + N to prompt the creation of a new branch, provide a name in the top red-circled box. For the case of this example, the branch is named "Example Script": 
![image](https://user-images.githubusercontent.com/115369420/196482414-10b64bf5-c38f-4220-87ca-816560a96cb9.png)

6) IMPORTANT -- Make sure that you create branch based on "_ Empty _"! This is not the default setting (which is highlighted in blue), but you can change it by clicking on the box that is circled in red:
![image](https://user-images.githubusercontent.com/115369420/196482656-2f9020a1-babf-4570-b118-41ffd80075de.png)
Failure to follow this step will result in your new branch attempting to copy over every script in the respository, and files will not display properly.

7) Click "Create branch", confirming that the "_ Empty _" box is now blue:
![image](https://user-images.githubusercontent.com/115369420/196482779-da333ddf-67c6-4884-81db-43951fe25282.png)

8) Note that your current branch has changed to whatever name you chose:
![image](https://user-images.githubusercontent.com/115369420/196482918-e6412c8d-8806-4f39-936d-08c5d1f65ac4.png)

9) In order to commit a new branch, it has to contain something. Add your named folder (in our case "Example_Script"), containing your script ("Example_Script.rms") and supporting files, as a subfolder to the respository directory:
![image](https://user-images.githubusercontent.com/115369420/196483013-a17a1b9a-c188-4580-8a84-a8c9eaeb4b38.png)

10) Note that the changes have been detected by Github Desktop (1) (the green plus-sign indicates that you are adding a file). Type in a summary (2) and hit "Commit to Example-Script" (3):
![image](https://user-images.githubusercontent.com/115369420/196483111-7336a6dc-7256-4c9a-9907-734772f03fda.png)

11) Click "Publish Branch" to share the new branch with the rest of the collaborators in this repository:
![image](https://user-images.githubusercontent.com/115369420/196504352-57e2de17-39ad-4021-aba8-135cd02d54aa.png)

If the branch already exists and you are making changes, then it will appear as a "push" instead:
![image](https://user-images.githubusercontent.com/115369420/196505995-6bdf9362-62c1-4648-8559-5bfff5577e48.png)

12) Note now that you can cycle through different branches and the contents of: C:\Program Files (x86)\Steam\steamapps\common\AoE2DE\resources\_common\random-map-scripts\Age-of-Empires-II-Definitive-Edition----Random-Map-Scripts will change depending on which branch you have selected. The disappearing files were not deleted or moved, they were simply hidden. Using branches allows us to customize what appears in the folder, and what is stashed in the cloud. The appearance and disappearance of files from this location also impacts your locally installed copy of the game. The branch you select through Github Desktop determines the visibility of random maps scripts in the scenario editor:
![image](https://user-images.githubusercontent.com/115369420/195188704-9df23df3-3f3d-45f6-8793-ebef0d36fb38.png) 
or in lobby custom map selection:

![image](https://user-images.githubusercontent.com/115369420/195189829-b59a3e71-a014-4c81-89aa-602594adca95.png). 
If you want your game to display all published maps in the repository, select the "Entire-Library" branch. If you wish to see none, select the "_ Empty _" branch. 




_____________________________________________________________________________________________________________________________________________________________
How to Publish Scripts to the "Entire-Library":

1) Change current branch to "Entire-Library".

2) Hit ctrl + shift + M to summon the merge commit menu, select the branch to merge into the Entire-Library (1), and hit "Create a merge commit" (2):
![image](https://user-images.githubusercontent.com/115369420/196814778-072a7841-f5b1-4fe2-bc83-31906663a1e7.png)

3) Note that your script folder (in course case, "Example_Script") now appears in the main library:
![image](https://user-images.githubusercontent.com/115369420/196483390-c4749401-4076-4616-8d32-fa1d410f054d.png)

Updating the files in "Entire-Library" is simple: repeat steps 1-3 with the new files.

_____________________________________________________________________________________________________________________________________________________________

Map Summary (refer to the template in this folder) are recommended for all maps you upload. This will help people looking for maps know that what you've created will work for their application!
