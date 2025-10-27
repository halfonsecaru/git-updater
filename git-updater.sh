#!/bin/bash

# Git Updater - Interactive script for uploading projects to GitHub
# Automates commits, branches, and pushes from the terminal

set -e

# Colors for better UI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Function to check if we're in a git repository
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        return 1
    fi
    return 0
}

# Function to initialize a new git repository
init_repo() {
    echo ""
    print_info "Initializing Git Repository"
    echo "================================"
    
    if check_git_repo; then
        print_warning "Already in a Git repository!"
        return
    fi
    
    git init
    print_success "Git repository initialized successfully!"
    
    read -p "Do you want to configure remote repository? (y/n): " configure
    if [[ $configure =~ ^[Yy]$ ]]; then
        configure_remote
    fi
}

# Function to configure remote repository
configure_remote() {
    echo ""
    print_info "Configure Remote Repository"
    echo "================================"
    
    # Check if remote already exists
    if git remote get-url origin > /dev/null 2>&1; then
        current_remote=$(git remote get-url origin)
        print_info "Current remote origin: $current_remote"
        read -p "Do you want to change it? (y/n): " change
        if [[ ! $change =~ ^[Yy]$ ]]; then
            return
        fi
        git remote remove origin
    fi
    
    read -p "Enter GitHub repository URL: " repo_url
    if [ -z "$repo_url" ]; then
        print_error "Repository URL cannot be empty!"
        return
    fi
    
    git remote add origin "$repo_url"
    print_success "Remote repository configured: $repo_url"
}

# Function to view current status
view_status() {
    echo ""
    print_info "Current Git Status"
    echo "================================"
    
    if ! check_git_repo; then
        print_error "Not in a Git repository!"
        return
    fi
    
    # Show current branch
    current_branch=$(git branch --show-current)
    if [ -n "$current_branch" ]; then
        echo -e "${BLUE}Current branch:${NC} $current_branch"
    else
        print_warning "No commits yet (HEAD detached)"
    fi
    
    # Show remote
    if git remote get-url origin > /dev/null 2>&1; then
        remote=$(git remote get-url origin)
        echo -e "${BLUE}Remote:${NC} $remote"
    else
        print_warning "No remote configured"
    fi
    
    echo ""
    git status
}

# Function to stage and commit changes
commit_changes() {
    echo ""
    print_info "Stage and Commit Changes"
    echo "================================"
    
    if ! check_git_repo; then
        print_error "Not in a Git repository! Please initialize first."
        return
    fi
    
    # Check if there are any changes
    if git diff --quiet && git diff --cached --quiet; then
        print_warning "No changes to commit!"
        return
    fi
    
    echo ""
    echo "Changed files:"
    git status --short
    
    echo ""
    echo "Options:"
    echo "1. Stage all changes"
    echo "2. Stage specific files"
    read -p "Choose option (1-2): " stage_option
    
    case $stage_option in
        1)
            git add .
            print_success "All changes staged"
            ;;
        2)
            read -p "Enter file paths (space-separated): " files
            if [ -z "$files" ]; then
                print_error "No files specified!"
                return
            fi
            git add $files
            print_success "Files staged"
            ;;
        *)
            print_error "Invalid option!"
            return
            ;;
    esac
    
    echo ""
    read -p "Enter commit message: " commit_msg
    if [ -z "$commit_msg" ]; then
        print_error "Commit message cannot be empty!"
        return
    fi
    
    git commit -m "$commit_msg"
    print_success "Changes committed successfully!"
}

# Function to create a new branch
create_branch() {
    echo ""
    print_info "Create New Branch"
    echo "================================"
    
    if ! check_git_repo; then
        print_error "Not in a Git repository! Please initialize first."
        return
    fi
    
    # Show current branches
    echo "Existing branches:"
    git branch
    
    echo ""
    read -p "Enter new branch name: " branch_name
    if [ -z "$branch_name" ]; then
        print_error "Branch name cannot be empty!"
        return
    fi
    
    read -p "Switch to new branch after creation? (y/n): " switch_branch
    
    if [[ $switch_branch =~ ^[Yy]$ ]]; then
        git checkout -b "$branch_name"
        print_success "Branch '$branch_name' created and checked out!"
    else
        git branch "$branch_name"
        print_success "Branch '$branch_name' created!"
    fi
}

# Function to switch branches
switch_branch() {
    echo ""
    print_info "Switch Branch"
    echo "================================"
    
    if ! check_git_repo; then
        print_error "Not in a Git repository! Please initialize first."
        return
    fi
    
    # Show current branches
    echo "Available branches:"
    git branch
    
    echo ""
    read -p "Enter branch name to switch to: " branch_name
    if [ -z "$branch_name" ]; then
        print_error "Branch name cannot be empty!"
        return
    fi
    
    git checkout "$branch_name"
    print_success "Switched to branch '$branch_name'!"
}

# Function to push changes
push_changes() {
    echo ""
    print_info "Push Changes to GitHub"
    echo "================================"
    
    if ! check_git_repo; then
        print_error "Not in a Git repository! Please initialize first."
        return
    fi
    
    # Check if remote is configured
    if ! git remote get-url origin > /dev/null 2>&1; then
        print_error "No remote repository configured!"
        read -p "Do you want to configure it now? (y/n): " configure
        if [[ $configure =~ ^[Yy]$ ]]; then
            configure_remote
        else
            return
        fi
    fi
    
    current_branch=$(git branch --show-current)
    if [ -z "$current_branch" ]; then
        print_error "No branch currently checked out!"
        return
    fi
    
    print_info "Pushing branch '$current_branch' to origin..."
    
    # Check if branch exists on remote
    if git ls-remote --heads origin "$current_branch" | grep -q "$current_branch"; then
        git push origin "$current_branch"
    else
        print_info "Branch doesn't exist on remote. Creating..."
        git push -u origin "$current_branch"
    fi
    
    print_success "Changes pushed successfully to GitHub!"
}

# Function to display the main menu
show_menu() {
    echo ""
    echo "╔════════════════════════════════════════╗"
    echo "║       Git Updater - Main Menu         ║"
    echo "╚════════════════════════════════════════╝"
    echo ""
    echo "1. Initialize Git Repository"
    echo "2. View Status"
    echo "3. Stage and Commit Changes"
    echo "4. Create New Branch"
    echo "5. Switch Branch"
    echo "6. Push Changes to GitHub"
    echo "7. Configure Remote Repository"
    echo "8. Exit"
    echo ""
}

# Main program loop
main() {
    clear
    echo "╔════════════════════════════════════════╗"
    echo "║          Welcome to Git Updater        ║"
    echo "║   Streamline your GitHub workflow!     ║"
    echo "╚════════════════════════════════════════╝"
    
    while true; do
        show_menu
        read -p "Choose an option (1-8): " choice
        
        case $choice in
            1)
                init_repo
                ;;
            2)
                view_status
                ;;
            3)
                commit_changes
                ;;
            4)
                create_branch
                ;;
            5)
                switch_branch
                ;;
            6)
                push_changes
                ;;
            7)
                configure_remote
                ;;
            8)
                echo ""
                print_success "Thanks for using Git Updater! Goodbye!"
                exit 0
                ;;
            *)
                print_error "Invalid option! Please choose 1-8."
                ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..."
    done
}

# Run the main program
main
