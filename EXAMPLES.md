# Git Updater - Example Usage

This document provides example scenarios for using Git Updater.

## Scenario 1: Starting a New Project

You have a new project folder and want to push it to GitHub:

1. Navigate to your project folder
2. Run `./git-updater.sh`
3. Choose **Option 1** - Initialize Git Repository
4. When prompted, choose **yes** to configure remote
5. Enter your GitHub repository URL (e.g., `https://github.com/username/repo.git`)
6. Choose **Option 3** - Stage and Commit Changes
7. Select **Option 1** to stage all files
8. Enter a commit message (e.g., "Initial commit")
9. Choose **Option 6** - Push Changes to GitHub
10. Your project is now on GitHub! 🎉

## Scenario 2: Working on an Existing Project

You've made changes and want to commit and push:

1. Run `./git-updater.sh`
2. Choose **Option 2** - View Status to see what changed
3. Choose **Option 3** - Stage and Commit Changes
4. Stage your changes (all or specific files)
5. Enter a descriptive commit message
6. Choose **Option 6** - Push Changes to GitHub
7. Done! ✓

## Scenario 3: Creating a Feature Branch

You want to work on a new feature in a separate branch:

1. Run `./git-updater.sh`
2. Choose **Option 4** - Create New Branch
3. Enter branch name (e.g., "feature/new-login")
4. Choose **yes** to switch to the new branch
5. Make your changes
6. Choose **Option 3** - Stage and Commit Changes
7. Choose **Option 6** - Push Changes to GitHub
8. Your feature branch is now on GitHub!

## Scenario 4: Quick Status Check

Just want to see what's going on:

1. Run `./git-updater.sh`
2. Choose **Option 2** - View Status
3. Review your current branch, remote, and file changes
4. Press Enter to return to menu or choose another option

## Scenario 5: Configuring Remote Later

You initialized without setting up remote:

1. Run `./git-updater.sh`
2. Choose **Option 7** - Configure Remote Repository
3. Enter your GitHub repository URL
4. Now you can push changes using Option 6

## Tips for Efficient Workflow

- **Before coding**: Check status (Option 2)
- **During coding**: Commit frequently (Option 3)
- **After coding**: Push to GitHub (Option 6)
- **For new features**: Create a branch first (Option 4)
- **Switching tasks**: Use switch branch (Option 5)

## Common Workflows

### Daily Update Workflow
```
View Status → Stage & Commit → Push Changes
(Option 2)    (Option 3)        (Option 6)
```

### Feature Development Workflow
```
Create Branch → Switch Branch → Stage & Commit → Push Changes
(Option 4)      (Option 5)      (Option 3)        (Option 6)
```

### Project Setup Workflow
```
Initialize → Configure Remote → Stage & Commit → Push Changes
(Option 1)   (Option 7)         (Option 3)        (Option 6)
```

---

**Remember**: The interactive menu makes it easy - just follow the prompts!
