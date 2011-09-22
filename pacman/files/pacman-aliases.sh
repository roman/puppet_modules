# Pacman alias examples
alias pacupg='sudo pacman -Syu'  # Synchronize with repositories before upgrading packages that are out of date on the local system.
alias pacin='sudo pacman -S'     # Install specific package(s) from the repositories
alias pacins='sudo pacman -U'    # Install specific package not from the repositories but from a file 
alias pacre='sudo pacman -R'     # Remove the specified package(s), retaining its configuration(s) and required dependencies
alias pacrem='sudo pacman -Rns'  # Remove the specified package(s), its configuration(s) and unneeded dependencies
alias pacrep='pacman -Si'        # Display information about a given package in the repositories
alias pacreps='pacman -Ss'       # Search for package(s) in the repositories
alias pacloc='pacman -Qi'        # Display information about a given package in the local database
alias paclocs='pacman -Qs'       # Search for package(s) in the local database
