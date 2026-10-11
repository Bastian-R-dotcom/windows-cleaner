
# Windows cleaner

A powerful Windows cleaner that allows anyone to clean their computer safely.

It doesn't break : 
- Any personal user data (documents, photos, downloads, etc.),
- The user's ability to automatically log in to website and app accounts,
- The behavior of Windows and other programs.

## Get started

#### 1. Download the script from an official release of the Windows Cleaner repository : https://github.com/Bastian-R-dotcom/windows-cleaner/releases,
#### 2. Place the .bat file on your desktop so you can easily access it, 
#### 3. Open Command Prompt as an administrator,
#### 4. Navigate to your desktop folder by typing the following command in Command Prompt : `cd /d "%USERPROFILE%\Desktop"`,
#### 5. Run the script by typing the following command in Command Prompt : `<script_name>.bat`.

## Contributing as a user

Contributions are always welcome!

If you encounter any bugs while using Windows Cleaner or have ideas for new features, feel free to open a new issue here: https://github.com/Bastian-R-dotcom/windows-cleaner/issues.

## Contributing as a developer

New to GitHub ? No problem, just follow these steps :

#### 1. Fork and clone
Click **Fork** (top right of this page) to create your own copy of the project. Then click **Code** on your fork, copy the link, and run:

    git clone <the-link-you-copied>

#### 2. Create a branch
A branch is a separate workspace for your change. Name it `fix/...` for a bug fix or `feature/...` for a new feature:

    git checkout -b fix/temp-files-cleanup

#### 3. Make and test your changes
Edit the files, then run the cleaner and check that it:
- **does not delete personal user data** (documents, photos, downloads, etc.),
- **does not log users out** of their website and app accounts,
- **does not break Windows or other programs**.

Ideally, test on a virtual machine or a spare PC, not on your main computer.

#### 4. Commit and push
Save your changes with a short message, then upload your branch to your fork:

    git add .
    git commit -m "Fix temp files cleanup"
    git push origin fix/temp-files-cleanup

#### 5. Open a pull request
On your fork, click **Compare & pull request** and explain **what you changed** and **why**. Your work is reviewed before it is merged, so don't worry about mistakes.



