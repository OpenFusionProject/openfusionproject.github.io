#!/usr/bin/env sh

###########################################
# Global Variables
###########################################

# Server version constants
VERSION_ORIGINAL="original"
VERSION_ACADEMY="academy"

# UUIDs for API configuration
UUID_ORIGINAL="ec8063b2-54d4-4ee1-8d9e-381f5babd420"
UUID_ACADEMY="6543a2bb-d154-4087-b9ee-3c8aa778580a"

# Base installation directory
BASE_DIR="/opt/openfusion"

# Temporary build directory for ofapi
OFAPI_BUILD_DIR="/tmp/ofapi-build"

# Variables to be set by user input
INSTALL_ORIGINAL=0
INSTALL_ACADEMY=0
SERVER_TYPE=""  # "simple" or "endpoint"
SERVER_NAME=""
ACCOUNT_LEVEL=99

###########################################
# Utils
###########################################

# Print ASCII art header
print_ascii_header() {
    cat << 'EOF'
   ___                   ______          _
  / _ \ _ __   ___ _ __ |  ____|        (_)
 | | | | '_ \ / _ \ '_ \| |__ _   _ ___ _  ___  _ __
 | | | | |_) |  __/ | | |  __| | | / __| |/ _ \| '_ \
 | |_| | .__/ \___|_| |_| |  | |_| \__ \ | (_) | | | |
  \___/|_|              |_|   \__,_|___/_|\___/|_| |_|

EOF
}

# Color codes for terminal output
COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_BLUE='\033[0;34m'
COLOR_CYAN='\033[0;36m'
COLOR_YELLOW='\033[1;33m'
COLOR_RESET='\033[0m'

# Print a header with color
print_header() {
    echo ""
    printf "${COLOR_CYAN}==========================================\n"
    printf "%s\n" "$1"
    printf "==========================================${COLOR_RESET}\n"
}

# Print an error message and exit
print_error() {
    printf "${COLOR_RED}[ERROR]${COLOR_RESET} %s\n" "$1"
    exit 1
}

# Print a success message
print_success() {
    printf "${COLOR_GREEN}[OK]${COLOR_RESET} %s\n" "$1"
}

# Print a warning message
print_warning() {
    printf "${COLOR_YELLOW}[WARNING]${COLOR_RESET} %s\n" "$1"
}

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check all requirements including root access and dependencies
check_requirements() {
    # Check if the user is root
    if [ "$(id -u)" -ne 0 ]; then
        print_error "This script must be run as root\nPlease run: sudo $0"
    fi

    print_header "Checking Dependencies"

    local missing_deps=""
    local version_issues=""

    for cmd in wget unzip curl; do
        if ! command_exists "$cmd"; then
            missing_deps="$missing_deps $cmd"
        else
            print_success "$cmd is installed"
        fi
    done


    # Check GLIBC version (required: 2.38 or higher)
    echo "Checking system library versions..."
    if command_exists "ldd"; then
        local glibc_version=$(ldd --version 2>&1 | head -n 1 | grep -oE '[0-9]+\.[0-9]+' | head -n 1)
        if [ -n "$glibc_version" ]; then
            # Convert version to comparable integer (e.g., 2.38 -> 238)
            local glibc_major=$(echo "$glibc_version" | cut -d. -f1)
            local glibc_minor=$(echo "$glibc_version" | cut -d. -f2)
            local glibc_ver_int=$((glibc_major * 100 + glibc_minor))

            if [ "$glibc_ver_int" -lt 238 ]; then
                version_issues="${version_issues}\n  - GLIBC version $glibc_version found, but 2.38 or higher is required"
                print_warning "GLIBC $glibc_version (need 2.38+)"
            else
                print_success "GLIBC $glibc_version"
            fi
        fi
    fi

    # Check GLIBCXX version (required: 3.4.32 or higher)
    if [ -f "/usr/lib/x86_64-linux-gnu/libstdc++.so.6" ] || [ -f "/usr/lib64/libstdc++.so.6" ]; then
        local libstdc_path="/usr/lib/x86_64-linux-gnu/libstdc++.so.6"
        if [ ! -f "$libstdc_path" ]; then
            libstdc_path="/usr/lib64/libstdc++.so.6"
        fi

        # Check if GLIBCXX_3.4.32 is available
        if strings "$libstdc_path" 2>/dev/null | grep -q "GLIBCXX_3.4.32"; then
            print_success "GLIBCXX 3.4.32+ available"
        else
            # Get the highest version available
            local highest_glibcxx=$(strings "$libstdc_path" 2>/dev/null | grep "GLIBCXX_3.4" | sort -V | tail -n 1)
            version_issues="${version_issues}\n  - GLIBCXX_3.4.32 not found (found: $highest_glibcxx)"
            print_warning "GLIBCXX $highest_glibcxx (need 3.4.32+)"
        fi
    else
        version_issues="${version_issues}\n  - libstdc++.so.6 not found"
        print_warning "libstdc++.so.6 not found"
    fi

    # Exit if any dependencies are missing
    if [ -n "$missing_deps" ]; then
        print_error "Missing required dependencies:$missing_deps\nPlease install them and run this script again."
    fi

    # Warn about version issues but don't exit (user might be checking before upgrading)
    if [ -n "$version_issues" ]; then
        echo ""
        printf "${COLOR_YELLOW}[WARNING] System library version issues detected:${COLOR_RESET}\n"
        printf "${version_issues}\n"
        echo ""
        echo "OpenFusion server requires:"
        echo "  - GLIBC 2.38 or higher"
        echo "  - GLIBCXX 3.4.32 or higher"
        echo ""
        echo "The server binary will not run without these versions."
        echo "Consider upgrading your system or using a newer distribution."
        echo ""
        printf "Do you want to continue anyway? (y/N): "
        read -r continue_choice
        case "$continue_choice" in
            [Yy]|[Yy][Ee][Ss])
                print_warning "Continuing despite version issues..."
                ;;
            *)
                echo "Setup cancelled."
                exit 1
                ;;
        esac
    fi

    print_success "All dependencies are satisfied"
}

###########################################
# User Prompts
###########################################

prompt_version_selection() {
    print_header "Server Version Selection"

    echo "Which version(s) would you like to install?"
    echo "1) Original"
    echo "2) Academy"
    echo "3) Both"
    echo ""

    # Loop until valid choice is made
    while true; do
        printf "Enter your choice [1-3]: "
        read -r version_choice

        case "$version_choice" in
            1)
                INSTALL_ORIGINAL=1
                print_success "Installing: Original"
                break
                ;;
            2)
                INSTALL_ACADEMY=1
                print_success "Installing: Academy"
                break
                ;;
            3)
                INSTALL_ORIGINAL=1
                INSTALL_ACADEMY=1
                print_success "Installing: Both Original and Academy"
                break
                ;;
            *)
                print_warning "Invalid choice. Please enter 1, 2, or 3."
                ;;
        esac
    done
}

prompt_server_type() {
    print_header "Server Type Selection"

    echo "What type of server would you like to setup?"
    echo "1) Simple Server (basic server, no API)"
    echo "2) Endpoint Server (with OpenFusion API for account management)"
    echo ""

    # Loop until valid choice is made
    while true; do
        printf "Enter your choice [1-2]: "
        read -r type_choice

        case "$type_choice" in
            1)
                SERVER_TYPE="simple"
                print_success "Server type: Simple"
                break
                ;;
            2)
                SERVER_TYPE="endpoint"

                # Check for cargo if endpoint server is selected
                if [ "$SERVER_TYPE" = "endpoint" ]; then
                    if ! command_exists "cargo"; then
                        print_error "cargo is not installed but is required for endpoint servers.\nPlease install Rust and Cargo from https://rustup.rs/ and run this script again."
                        exit 1
                    else
                        print_success "Server type: Endpoint (with API)"
                    fi
                fi
                break
                ;;
            *)
                print_warning "Invalid choice. Please enter 1 or 2."
                ;;
        esac
    done
}

prompt_server_info() {
    print_header "Server Configuration"

    # Prompt for server name if endpoint server
    if [ "$SERVER_TYPE" = "endpoint" ]; then
        printf "Enter server name (e.g., 'My OpenFusion Server'): "
        read -r SERVER_NAME
        if [ -z "$SERVER_NAME" ]; then
            SERVER_NAME="OpenFusion Server"
        fi
        print_success "Server name: $SERVER_NAME"
    fi

    # Prompt for account level
    echo ""
    echo "Account permission levels:"
    echo "  1  = Allow ALL commands"
    echo "  30 = Allow some 'abusable' commands like /summon"
    echo "  50 = Only allow cheat commands like /itemN and /speed"
    echo "  99 = Standard user account, no cheats (RECOMMENDED)"
    echo ""
    printf "Enter account level [99]: "
    read -r ACCOUNT_LEVEL
    if [ -z "$ACCOUNT_LEVEL" ]; then
        ACCOUNT_LEVEL=99
    fi
    print_success "Account level: $ACCOUNT_LEVEL"
}

###########################################
# User & Directory Setup
###########################################

setup_user_and_directories() {
    print_header "Setting Up User and Directories"

    # Create fusion group if it doesn't exist
    if ! getent group fusion >/dev/null 2>&1; then
        groupadd --system fusion
        print_success "Created fusion group"
    else
        print_success "fusion group already exists"
    fi

    # Create fusion user if it doesn't exist
    if ! id -u fusion >/dev/null 2>&1; then
        useradd --system -g fusion -d "$BASE_DIR" -s /bin/false fusion
        print_success "Created fusion user"
    else
        print_success "fusion user already exists"
    fi

    # Create base directory
    mkdir -p "$BASE_DIR"
    print_success "Created $BASE_DIR"

    # Create directories for selected versions
    if [ "$INSTALL_ORIGINAL" -eq 1 ]; then
        mkdir -p "$BASE_DIR/original"
        print_success "Created $BASE_DIR/original"
    fi

    if [ "$INSTALL_ACADEMY" -eq 1 ]; then
        mkdir -p "$BASE_DIR/academy"
        print_success "Created $BASE_DIR/academy"
    fi

    # Set ownership
    chown -R fusion:fusion "$BASE_DIR"
    print_success "Set ownership to fusion:fusion"
}

###########################################
# Server File Download & Extraction
###########################################

download_and_extract_server() {
    local version=$1
    local version_dir="$BASE_DIR/$version"

    print_header "Downloading OpenFusion Server - $version"

    # Get latest release information from GitHub API
    echo "Fetching latest release information..."
    local release_json
    release_json=$(curl -s https://api.github.com/repos/OpenFusionProject/OpenFusion/releases/latest)

    if [ -z "$release_json" ]; then
        print_error "Failed to fetch release information from GitHub"
    fi

    # Determine the correct asset name based on version
    local asset_name
    if [ "$version" = "$VERSION_ORIGINAL" ]; then
        asset_name="OpenFusionServer-Linux-Original.zip"
    else
        asset_name="OpenFusionServer-Linux-Academy.zip"
    fi

    # Extract download URL for the specific asset
    local download_url
    download_url=$(echo "$release_json" | grep -o "\"browser_download_url\":[[:space:]]*\"[^\"]*$asset_name\"" | grep -o 'https://[^"]*')

    if [ -z "$download_url" ]; then
        print_error "Could not find download URL for $asset_name"
    fi

    print_success "Found download URL"

    # Download the server files
    echo "Downloading $asset_name..."
    local temp_file="/tmp/$asset_name"
    if ! wget -q --show-progress -O "$temp_file" "$download_url"; then
        print_error "Failed to download server files"
    fi
    print_success "Downloaded server files"

    # Extract to the version directory
    echo "Extracting server files..."
    mkdir -p "$version_dir/server"
    if ! unzip -q "$temp_file" -d "$version_dir/server"; then
        print_error "Failed to extract server files"
    fi

    # Move files up one level if they were extracted into a subdirectory
    local extracted_dir=$(find "$version_dir/server" -mindepth 1 -maxdepth 1 -type d | head -n 1)
    if [ -n "$extracted_dir" ]; then
        mv "$extracted_dir"/* "$version_dir/server/" 2>/dev/null || true
        rmdir "$extracted_dir" 2>/dev/null || true
    fi

    chmod +x "$version_dir/server/fusion"

    print_success "Extracted server files to $version_dir/server"

    # Clean up
    rm "$temp_file"

    # Set ownership
    chown -R fusion:fusion "$version_dir"
}

###########################################
# Server Configuration
###########################################

configure_server_ini() {
    local version=$1
    local config_file="$BASE_DIR/$version/server/config.ini"

    print_header "Configuring Server - $version"

    if [ ! -f "$config_file" ]; then
        print_error "Config file not found: $config_file"
    fi

    # Set ports based on version
    local login_port shard_port monitor_port
    if [ "$version" = "$VERSION_ORIGINAL" ]; then
        login_port=23000
        shard_port=23001
        monitor_port=8003
    else
        login_port=24000
        shard_port=24001
        monitor_port=8004
    fi

    # Backup original config
    cp "$config_file" "$config_file.backup"

    # Update login port (POSIX compliant sed)
    sed "s/^port[[:space:]]*=.*/port=$login_port/" "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"
    print_success "Set login port to $login_port"

    # Update shard port and IP (POSIX compliant sed)
    # Find the [shard] section and update the port
    sed "/^\[shard\]/,/^\[/ s/^port[[:space:]]*=.*/port=$shard_port/" "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"
    print_success "Set shard port to $shard_port"

    # Update shard IP (using 127.0.0.1 as default)
    sed "/^\[shard\]/,/^\[/ s/^ip[[:space:]]*=.*/ip=127.0.0.1/" "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"
    print_success "Set shard IP to 127.0.0.1 (change this for network access)"

    # Update monitor port
    sed "/^\[monitor\]/,/^\[/ s/^port[[:space:]]*=.*/port=$monitor_port/" "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"
    print_success "Set monitor port to $monitor_port"

    # Update account level
    sed "/^\[account\]/,/^\[/ s/^defaultaccountlevel[[:space:]]*=.*/defaultaccountlevel=$ACCOUNT_LEVEL/" "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"
    print_success "Set default account level to $ACCOUNT_LEVEL"

    print_success "Configuration complete"
}

###########################################
# Endpoint Server Setup
###########################################

build_ofapi_once() {
    print_header "Building OpenFusion API"

    # Download ofapi
    # Latest tag not available here, so version is hardcoded
    local ofapi_url="https://github.com/OpenFusionProject/ofapi/archive/refs/tags/v1.0.1.tar.gz"
    local temp_file="/tmp/ofapi-1.0.1.tar.gz"

    echo "Downloading OpenFusion API..."
    if ! wget -q --show-progress -O "$temp_file" "$ofapi_url"; then
        print_error "Failed to download OpenFusion API"
    fi
    print_success "Downloaded OpenFusion API"

    # Extract ofapi to temporary build directory
    echo "Extracting OpenFusion API..."
    mkdir -p "$OFAPI_BUILD_DIR"
    if ! tar -xzf "$temp_file" -C "$OFAPI_BUILD_DIR" --strip-components=1; then
        print_error "Failed to extract OpenFusion API"
    fi
    print_success "Extracted OpenFusion API"

    # Clean up tarball
    rm "$temp_file"

    # Build ofapi (only once!)
    echo "Building OpenFusion API (this may take a few minutes)..."
    cd "$OFAPI_BUILD_DIR" || print_error "Failed to change to build directory"

    if ! cargo build --release 2>&1; then
        print_error "Failed to build OpenFusion API"
    fi
    print_success "Built OpenFusion API binary"

    # Return to original directory
    cd - >/dev/null || true
}

setup_ofapi_for_version() {
    local version=$1
    local version_dir="$BASE_DIR/$version"

    print_header "Setting up OpenFusion API - $version"

    # Create ofapi directory for this version
    mkdir -p "$version_dir/ofapi"

    # Copy the built binary
    echo "Copying ofapi binary..."
    cp "$OFAPI_BUILD_DIR/target/release/ofapi" "$version_dir/ofapi/"
    print_success "Copied binary to $version_dir/ofapi/"

    # Copy necessary files (templates, config.toml)
    echo "Copying configuration files..."
    if [ -d "$OFAPI_BUILD_DIR/templates" ]; then
        cp -r "$OFAPI_BUILD_DIR/templates" "$version_dir/ofapi/"
        print_success "Copied templates directory"
    fi

    if [ -f "$OFAPI_BUILD_DIR/config.toml" ]; then
        cp "$OFAPI_BUILD_DIR/config.toml" "$version_dir/ofapi/"
        print_success "Copied config.toml"
    fi

    if [ -f "$OFAPI_BUILD_DIR/statics.csv" ]; then
        cp "$OFAPI_BUILD_DIR/statics.csv" "$version_dir/ofapi/"
        print_success "Copied statics.csv"
    fi

    # Set ownership
    chown -R fusion:fusion "$version_dir/ofapi"

    print_success "OpenFusion API setup complete for $version"
}

configure_ofapi_toml() {
    local version=$1
    local version_dir="$BASE_DIR/$version"
    local config_file="$version_dir/ofapi/config.toml"

    print_header "Configuring OpenFusion API - $version"

    # Set ports and addresses based on version
    local http_port tls_port login_port monitor_port uuid
    if [ "$version" = "$VERSION_ORIGINAL" ]; then
        http_port=8888
        tls_port=4433
        login_port=23000
        monitor_port=8003
        uuid="$UUID_ORIGINAL"
    else
        http_port=9999
        tls_port=5544
        login_port=24000
        monitor_port=8004
        uuid="$UUID_ACADEMY"
    fi

    # Generate random auth secret
    local auth_secret
    auth_secret=$(date +%s | sha256sum | base64 | head -c 32)

    # Backup original config
    cp "$config_file" "$config_file.backup"

    # Update config.toml using sed (POSIX compliant)
    # Escape special characters in variables for sed
    local uuid_escaped=$(echo "$uuid" | sed 's/[\/&]/\\&/g')
    local secret_escaped=$(echo "$auth_secret" | sed 's/[\/&]/\\&/g')
    local server_name_escaped=$(echo "$SERVER_NAME" | sed 's/[\/&]/\\&/g')

    # Update [core] section
    sed "s/^server_name[[:space:]]*=.*/server_name = \"$server_name_escaped\"/" "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"
    sed "s/^public_url[[:space:]]*=.*/public_url = \"localhost\"/" "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"
    sed "s|^db_path[[:space:]]*=.*|db_path = \"..\/server\/database.db\"|" "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"
    sed "s/^bind_ip[[:space:]]*=.*/bind_ip = \"127.0.0.1\"/" "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"
    sed "/^\[core\]/,/^\[/ s/^port[[:space:]]*=.*/port = $http_port/" "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"

    # Update [tls] section
    sed "/^\[tls\]/,/^\[/ s/^port[[:space:]]*=.*/port = $tls_port/" "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"

    # Update [game] section
    sed "/^\[game\]/,/^\[/ s/^versions[[:space:]]*=.*/versions = [\"$uuid_escaped\"]/" "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"
    sed "/^\[game\]/,/^\[/ s/^login_address[[:space:]]*=.*/login_address = \"localhost:$login_port\"/" "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"

    # Update [monitor] section
    sed "/^\[monitor\]/,/^\[/ s/^monitor_ip[[:space:]]*=.*/monitor_ip = \"127.0.0.1:$monitor_port\"/" "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"

    # Update [account] section
    sed "/^\[account\]/,/^\[/ s/^account_level[[:space:]]*=.*/account_level = $ACCOUNT_LEVEL/" "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"

    # Update [auth] section - secret_path
    sed "/^\[auth\]/,/^\[/ s/^secret_path[[:space:]]*=.*/secret_path = \"$secret_escaped\"/" "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"

    print_success "Configured config.toml"
    print_success "HTTP port: $http_port, TLS port: $tls_port"

    # Set ownership
    chown fusion:fusion "$config_file"
}

###########################################
# Systemd Service Creation
###########################################

create_server_service() {
    local version=$1
    local service_file="$BASE_DIR/$version/openfusion-$version.service"
    local systemd_link="/etc/systemd/system/openfusion-$version.service"

    print_header "Creating Systemd Service - openfusion-$version"

    # Create service file in base directory
    cat > "$service_file" << EOF
[Unit]
Description=OpenFusion Server - $version
After=network-online.target
Wants=network-online.target

[Service]
WorkingDirectory=$BASE_DIR/$version/server
ExecStart=$BASE_DIR/$version/server/fusion
Restart=on-failure
RestartSec=10
User=fusion
Group=fusion
Type=simple
TimeoutStartSec=300
TimeoutStopSec=120

[Install]
WantedBy=multi-user.target
EOF

    # Set ownership
    chown fusion:fusion "$service_file"

    # Create symlink to systemd directory
    ln -sf "$service_file" "$systemd_link"

    print_success "Created service file and symlinked to systemd"
}

create_ofapi_service() {
    local version=$1
    local service_file="$BASE_DIR/$version/openfusionapi-$version.service"
    local systemd_link="/etc/systemd/system/openfusionapi-$version.service"

    print_header "Creating Systemd Service - openfusionapi-$version"

    # Create service file in base directory
    cat > "$service_file" << EOF
[Unit]
Description=OpenFusion API - $version
After=network-online.target
Wants=network-online.target

[Service]
WorkingDirectory=$BASE_DIR/$version/ofapi
ExecStart=$BASE_DIR/$version/ofapi/ofapi
Restart=on-failure
RestartSec=10
User=fusion
Group=fusion
Type=simple
TimeoutStartSec=300
TimeoutStopSec=120

[Install]
WantedBy=multi-user.target
EOF

    # Set ownership
    chown fusion:fusion "$service_file"

    # Create symlink to systemd directory
    ln -sf "$service_file" "$systemd_link"

    print_success "Created service file and symlinked to systemd"
}

###########################################
# Final Instructions
###########################################

print_final_instructions() {
    print_header "Installation Complete!"

    echo ""
    echo "SUMMARY:"
    echo "--------"

    if [ "$INSTALL_ORIGINAL" -eq 1 ]; then
        echo "✓ Installed OpenFusion Original"
        echo "  - Server directory: $BASE_DIR/original/server"
        echo "  - Config file: $BASE_DIR/original/server/config.ini"
        echo "  - Login port: 23000, Shard port: 23001"
        if [ "$SERVER_TYPE" = "endpoint" ]; then
            echo "  - API directory: $BASE_DIR/original/ofapi"
            echo "  - API config: $BASE_DIR/original/ofapi/config.toml"
            echo "  - API HTTP port: 8888, TLS port: 4433"
        fi
    fi

    if [ "$INSTALL_ACADEMY" -eq 1 ]; then
        echo "✓ Installed OpenFusion Academy"
        echo "  - Server directory: $BASE_DIR/academy/server"
        echo "  - Config file: $BASE_DIR/academy/server/config.ini"
        echo "  - Login port: 24000, Shard port: 24001"
        if [ "$SERVER_TYPE" = "endpoint" ]; then
            echo "  - API directory: $BASE_DIR/academy/ofapi"
            echo "  - API config: $BASE_DIR/academy/ofapi/config.toml"
            echo "  - API HTTP port: 9999, TLS port: 5544"
        fi
    fi

    echo ""
    echo "NEXT STEPS:"
    echo "-----------"
    echo ""
    echo "1. Configure IP Address:"
    echo "   Edit the config.ini file(s) and change the 'ip' setting in the [shard]"
    echo "   section to:"
    echo "   - Your local network IP for LAN access"
    echo "   - Your public IP or domain for internet access"
    echo ""

    if [ "$SERVER_TYPE" = "endpoint" ]; then
        echo "2. Configure API Domain:"
        echo "   Edit the config.toml file(s) and change 'public_url' and 'login_address'"
        echo "   to your actual domain or IP address"
        echo ""
        echo "3. Setup Reverse Proxy (Nginx/Caddy) with TLS/SSL certificates"
        echo "   This is REQUIRED for endpoint servers!"
        echo "   See the guide: https://openfusionproject.github.io/docs/guides/setting-up-your-own-server/"
        echo ""
    fi

    local step_num=2
    if [ "$SERVER_TYPE" = "endpoint" ]; then
        step_num=4
    fi

    echo "$step_num. Open Firewall Ports:"
    echo "   Make sure the following ports are open in your firewall and router:"
    if [ "$INSTALL_ORIGINAL" -eq 1 ]; then
        echo "   - Original: 23000 (login), 23001 (shard)"
    fi
    if [ "$INSTALL_ACADEMY" -eq 1 ]; then
        echo "   - Academy: 24000 (login), 24001 (shard)"
    fi
    if [ "$SERVER_TYPE" = "endpoint" ]; then
        echo "   - HTTP: 80, HTTPS: 443 (for reverse proxy)"
    fi
    echo ""

    step_num=$((step_num + 1))
    echo "$step_num. Start the Services:"
    echo "   After completing the configuration, run these commands:"
    echo ""
    echo "   systemctl daemon-reload"

    if [ "$INSTALL_ORIGINAL" -eq 1 ]; then
        echo "   systemctl enable openfusion-original.service"
        echo "   systemctl start openfusion-original.service"
        if [ "$SERVER_TYPE" = "endpoint" ]; then
            echo "   systemctl enable openfusionapi-original.service"
            echo "   systemctl start openfusionapi-original.service"
        fi
    fi

    if [ "$INSTALL_ACADEMY" -eq 1 ]; then
        echo "   systemctl enable openfusion-academy.service"
        echo "   systemctl start openfusion-academy.service"
        if [ "$SERVER_TYPE" = "endpoint" ]; then
            echo "   systemctl enable openfusionapi-academy.service"
            echo "   systemctl start openfusionapi-academy.service"
        fi
    fi

    echo ""
    step_num=$((step_num + 1))
    echo "$step_num. Check Service Status:"
    echo "   systemctl status openfusion-*"
    if [ "$SERVER_TYPE" = "endpoint" ]; then
        echo "   systemctl status openfusionapi-*"
    fi

    echo ""
    echo "For more information, see the complete guide at:"
    echo "https://openfusionproject.github.io/docs/guides/setting-up-your-own-server/"
    echo ""
}

###########################################
# Main Flow: Initial Server Setup
###########################################

initial_server_setup() {
    # Check requirements first (includes root check and dependencies)
    check_requirements

    prompt_version_selection
    prompt_server_type
    prompt_server_info

    setup_user_and_directories

    # Build ofapi once if endpoint server is selected
    if [ "$SERVER_TYPE" = "endpoint" ]; then
        build_ofapi_once
    fi

    # Setup Original version if selected
    if [ "$INSTALL_ORIGINAL" -eq 1 ]; then
        download_and_extract_server "$VERSION_ORIGINAL"
        configure_server_ini "$VERSION_ORIGINAL"

        if [ "$SERVER_TYPE" = "endpoint" ]; then
            setup_ofapi_for_version "$VERSION_ORIGINAL"
            configure_ofapi_toml "$VERSION_ORIGINAL"
        fi

        create_server_service "$VERSION_ORIGINAL"
        if [ "$SERVER_TYPE" = "endpoint" ]; then
            create_ofapi_service "$VERSION_ORIGINAL"
        fi
    fi

    # Setup Academy version if selected
    if [ "$INSTALL_ACADEMY" -eq 1 ]; then
        download_and_extract_server "$VERSION_ACADEMY"
        configure_server_ini "$VERSION_ACADEMY"

        if [ "$SERVER_TYPE" = "endpoint" ]; then
            setup_ofapi_for_version "$VERSION_ACADEMY"
            configure_ofapi_toml "$VERSION_ACADEMY"
        fi

        create_server_service "$VERSION_ACADEMY"
        if [ "$SERVER_TYPE" = "endpoint" ]; then
            create_ofapi_service "$VERSION_ACADEMY"
        fi
    fi

    # Clean up temporary build directory
    if [ "$SERVER_TYPE" = "endpoint" ]; then
        echo ""
        echo "Cleaning up temporary build files..."
        rm -rf "$OFAPI_BUILD_DIR"
        print_success "Cleanup complete"
    fi

    print_final_instructions
}

###########################################
# Main Flow: Proxy & TLS Setup
###########################################

proxy_tls_setup() {
    print_header "Proxy & TLS Setup"
    echo ""
    echo "This feature will configure Nginx/Caddy and SSL certificates"
    echo "for your OpenFusion endpoint server."
    echo ""
    echo "Coming soon!"
    echo ""
}

###########################################
# Usage Information
###########################################

show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "OpenFusion Server Bootstrapper - Automated server setup"
    echo ""
    echo "Options:"
    echo "  --proxy-setup    Configure Nginx/Caddy reverse proxy and TLS (Coming Soon)"
    echo "  --help, -h       Show this help message"
    echo ""
    echo "Default behavior (no options): Run initial server setup"
    echo ""
    echo "Examples:"
    echo "  sudo $0                  # Run initial server setup"
    echo "  sudo $0 --proxy-setup    # Configure proxy and TLS"
    echo ""
}

###########################################
# Script Entry Point
###########################################

clear
printf "${COLOR_CYAN}"
print_ascii_header
printf "${COLOR_RESET}\n"
echo "    Automated Server Setup for OpenFusion"
echo ""
check_requirements

# Parse command line arguments
if [ "$1" = "--proxy-setup" ]; then
    proxy_tls_setup
elif [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_usage
    exit 0
elif [ -n "$1" ]; then
    echo "Error: Unknown option '$1'"
    echo ""
    show_usage
    exit 1
else
    # Default: Run initial server setup
    initial_server_setup
fi
