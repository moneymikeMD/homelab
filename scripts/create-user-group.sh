#!/bin/bash

# Script to create a user and group with specified IDs
# Usage: ./create-user-group.sh -u <username> -i <uid> -g <groupname> -d <gid>

# Function to display help
show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Create a user and group with specified IDs.

OPTIONS:
    -u, --user       USERNAME    Name of the user to create
    -i, --uid        UID         User ID (numeric)
    -g, --group      GROUPNAME   Name of the group to create
    -d, --gid        GID         Group ID (numeric)
    -h, --help                   Display this help message

EXAMPLE:
    $(basename "$0") -u dockermedia -i 3006 -g dockermedia -d 3006
    $(basename "$0") --user john --uid 1500 --group developers --gid 1500

EOF
    exit 0
}

# Initialize variables
USERNAME=""
UID_NUM=""
GROUPNAME=""
GID_NUM=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -u|--user)
            USERNAME="$2"
            shift 2
            ;;
        -i|--uid)
            UID_NUM="$2"
            shift 2
            ;;
        -g|--group)
            GROUPNAME="$2"
            shift 2
            ;;
        -d|--gid)
            GID_NUM="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            ;;
        *)
            echo "Error: Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Validate that all required parameters are provided
if [[ -z "$USERNAME" || -z "$UID_NUM" || -z "$GROUPNAME" || -z "$GID_NUM" ]]; then
    echo "Error: All parameters are required"
    echo ""
    show_help
fi

# Validate that UID and GID are numeric
if ! [[ "$UID_NUM" =~ ^[0-9]+$ ]] || ! [[ "$GID_NUM" =~ ^[0-9]+$ ]]; then
    echo "Error: UID and GID must be numeric values"
    exit 1
fi

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "Error: This script must be run as root (use sudo)"
   exit 1
fi

# Check if group already exists
if getent group "$GROUPNAME" > /dev/null 2>&1; then
    echo "Warning: Group '$GROUPNAME' already exists"
    EXISTING_GID=$(getent group "$GROUPNAME" | cut -d: -f3)
    if [[ "$EXISTING_GID" != "$GID_NUM" ]]; then
        echo "Error: Existing group has GID $EXISTING_GID, but you specified $GID_NUM"
        exit 1
    fi
    echo "Using existing group '$GROUPNAME' with GID $GID_NUM"
else
    # Create the group
    echo "Creating group '$GROUPNAME' with GID $GID_NUM..."
    if groupadd -g "$GID_NUM" "$GROUPNAME"; then
        echo "✓ Group '$GROUPNAME' created successfully"
    else
        echo "Error: Failed to create group"
        exit 1
    fi
fi

# Check if user already exists
if id "$USERNAME" > /dev/null 2>&1; then
    echo "Error: User '$USERNAME' already exists"
    exit 1
fi

# Check if UID is already in use
if getent passwd "$UID_NUM" > /dev/null 2>&1; then
    echo "Error: UID $UID_NUM is already in use by another user"
    exit 1
fi

# Create the user
echo "Creating user '$USERNAME' with UID $UID_NUM..."
if useradd -u "$UID_NUM" -g "$GROUPNAME" -m -s /bin/bash "$USERNAME"; then
    echo "✓ User '$USERNAME' created successfully"
else
    echo "Error: Failed to create user"
    exit 1
fi

# Display the results
echo ""
echo "=== Summary ==="
echo "User created: $USERNAME"
echo "User ID: $UID_NUM"
echo "Primary group: $GROUPNAME"
echo "Group ID: $GID_NUM"
echo "Home directory: /home/$USERNAME"
echo ""
echo "Verification:"
id "$USERNAME"
echo ""
echo "To set a password for this user, run:"
echo "  sudo passwd $USERNAME"