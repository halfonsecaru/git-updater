# Git Updater 🚀

Interactive script with a menu to easily upload your projects to GitHub, automating commits, branches, and pushes from the terminal.

## Features ✨

- **Interactive Menu Interface**: Easy-to-use terminal menu for all Git operations
- **Initialize Repositories**: Quickly set up new Git repositories
- **Stage & Commit**: Commit changes with a guided workflow
- **Branch Management**: Create and switch between branches effortlessly
- **Push to GitHub**: Upload your changes to GitHub with one command
- **Status Monitoring**: View current repository status at a glance
- **Remote Configuration**: Set up and manage GitHub remote repositories
- **Error Handling**: Built-in validation and helpful error messages

## Installation 📦

1. Clone this repository:
```bash
git clone https://github.com/halfonsecaru/git-updater.git
cd git-updater
```

2. Make the script executable (if not already):
```bash
chmod +x git-updater.sh
```

3. (Optional) Add to your PATH for global access:
```bash
# Add to ~/.bashrc or ~/.zshrc
export PATH="$PATH:/path/to/git-updater"
```

## Usage 🎯

### Run the script:
```bash
./git-updater.sh
```

### Menu Options:

1. **Initialize Git Repository**
   - Creates a new Git repository in the current directory
   - Optionally configure remote repository

2. **View Status**
   - Shows current branch, remote, and file status
   - Displays uncommitted changes

3. **Stage and Commit Changes**
   - Stage all files or select specific files
   - Write commit message
   - Commit changes to the repository

4. **Create New Branch**
   - Create a new branch
   - Optionally switch to the new branch immediately

5. **Switch Branch**
   - View available branches
   - Switch to an existing branch

6. **Push Changes to GitHub**
   - Push current branch to GitHub
   - Automatically sets upstream if needed

7. **Configure Remote Repository**
   - Add or update GitHub remote URL
   - View current remote configuration

8. **Exit**
   - Exit the program

## Example Workflow 📝

```bash
# 1. Start the script
./git-updater.sh

# 2. Initialize a new repository (Option 1)
# 3. Configure remote GitHub URL (Option 7)
# 4. Make changes to your files
# 5. Stage and commit changes (Option 3)
# 6. Push to GitHub (Option 6)
```

## Requirements 📋

- Bash shell
- Git installed and configured
- GitHub account (for pushing changes)

## Benefits 💡

- **Save Time**: No need to type Git commands manually
- **Reduce Errors**: Guided workflow prevents common mistakes
- **Streamlined Workflow**: All operations in one place
- **Beginner Friendly**: Easy for Git newcomers
- **Efficient**: Perfect for quick updates and routine tasks

## Tips 💭

- Use option 2 (View Status) frequently to check your repository state
- Always review changed files before committing
- Use descriptive commit messages for better project history
- Create branches for new features or experiments

## License 📄

MIT License - Feel free to use and modify as needed!

## Contributing 🤝

Contributions are welcome! Feel free to submit issues or pull requests.

---

**Happy Coding!** 🎉
