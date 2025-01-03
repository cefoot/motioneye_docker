# Basis-Image
FROM debian:bookworm-slim
LABEL maintainer="Chris <@cefoot on x>"

# --- 1) Installations- und Build-Abhängigkeiten:
RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
      ca-certificates curl python3 fdisk python3-dev gcc libcurl4-openssl-dev libssl-dev \
      build-essential libjpeg62-turbo-dev libavformat-dev libavcodec-dev libavdevice-dev \
      libavutil-dev libswscale-dev libswresample-dev libpq-dev wget \
      autoconf automake autopoint pkgconf libtool libzip-dev libjpeg-dev git libwebp-dev \
      gettext libmicrohttpd-dev libcamera-tools libcamera-dev libcamera-v4l2 \
      python3-pip python3-setuptools python3-wheel \
    #  - Ende der deps
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# --- 2) Kompilieren & Installieren von Motion 4.7:
WORKDIR /tmp
RUN wget https://github.com/Motion-Project/motion/archive/refs/tags/release-4.7.0.tar.gz && \
    tar xzf release-4.7.0.tar.gz && \
    cd motion-release-4.7.0 && \
    autoreconf -fiv && \
    ./configure && \
    make && \
    make install && \
    cd .. && rm -rf release-4.7.0.tar.gz motion-release-4.7.0

# --- 3) Systemnutzer 'motion' anlegen
RUN addgroup --system motion && \
    adduser --system --ingroup motion motion

# --- 4) Python-Pakete und MotionEye installieren
#     (Du hast 'motioneye_init --skip-systemd --skip-apt-update' genutzt.)
RUN grep -q '^\[global\]' /etc/pip.conf || echo '[global]' >> /etc/pip.conf && \
    echo 'break-system-packages=true' >> /etc/pip.conf && \
    python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel && \
    # Installation von MotionEye (beta/pre-Version, siehe Schritt 43)
    python3 -m pip install --pre --no-cache-dir motioneye && \
    # Einmal motioneye_init (ohne systemd):
    motioneye_init --skip-systemd --skip-apt-update

# --- 5) Verzeichnisse für MotionEye
RUN mkdir -p /var/log/motioneye /var/lib/motioneye /etc/motioneye /run/motioneye && \
    chown motion:motion /var/log/motioneye /var/lib/motioneye /etc/motioneye /run/motioneye

# --- 6) Entrypoint-Skript kopieren
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# --- 7) Port freigeben & EntryPoint setzen
EXPOSE 8765
ENTRYPOINT ["/entrypoint.sh"]
