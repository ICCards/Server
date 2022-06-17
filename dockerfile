FROM alpine:latest

# Environment Variables
ENV GODOT_VERSION "3.4.4"
ENV GODOT_EXPORT_PRESET="Linux/X11"
ENV GODOT_GAME_NAME "FaeFolk"
ENV HTTPS_GIT_REPO "https://github.com/ICCards/Server.git"

# Updates and installs to the server
RUN apk update
RUN apk add --no-cache bash
RUN apk add --no-cache wget
RUN apk add --no-cache git

# Allow this to run Godot
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.31-r0/glibc-2.31-r0.apk
RUN apk add --allow-untrusted glibc-2.31-r0.apk

# Download Godot and export template, version is set from variables
RUN wget https://downloads.tuxfamily.org/godotengine/3.4.4/Godot_v3.4.4-stable_linux_headless.64.zip \
    && wget https://downloads.tuxfamily.org/godotengine/3.4.4/Godot_v3.4.4-stable_export_templates.tpz \
    && mkdir ~/.cache \
    && mkdir -p ~/.config/godot \
    && mkdir -p ~/.local/share/godot/templates/3.4.4.stable \
    && unzip Godot_v3.4.4-stable_linux_headless.64.zip \
    && mv Godot_v3.4.4-stable_linux_headless.64 /usr/local/bin/godot \
    && unzip Godot_v3.4.4-stable_export_templates.tpz \
    && mv templates/* ~/.local/share/godot/templates/3.4.4.stable \
    && rm -f Godot_v3.4.4-stable_export_templates.tpz Godot_v3.4.4-stable_linux_headless.64.zip

# Make needed directories for container
RUN mkdir /godotapp
RUN mkdir /godotbuildspace

# Move to the build space and export the .pck
WORKDIR /godotbuildspace
RUN ls
RUN git clone https://github.com/ICCards/Server.git .
RUN godot --path /godotbuildspace --export-pack Linux/X11 FaeFolk.pck
RUN mv FaeFolk.pck /godotapp/

# Change to the godotapp space, delete the source,  and run the app
WORKDIR /godotapp
run rm -f -R /godotbuildspace
CMD godot --main-pack FaeFolk.pck

EXPOSE 45124:65124/udp