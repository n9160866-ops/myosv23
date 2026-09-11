#!/usr/bin/env bash
set -e -u

# --- Services réseau / graphique ---
systemctl enable NetworkManager.service
systemctl enable lightdm.service
systemctl enable sshd.service

# --- Utilisateur live par défaut ---
useradd -m -G wheel,storage,power,audio,video -s /bin/bash evoos || true
echo "evoos:evoos" | chpasswd
echo "root:evoos" | chpasswd

# --- Sudo pour le groupe wheel ---
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# --- Sudo sans mot de passe pour lancer l'installeur Calamares depuis le live ---
echo "%wheel ALL=(ALL) NOPASSWD: /usr/bin/calamares" > /etc/sudoers.d/calamares
chmod 440 /etc/sudoers.d/calamares

# --- Rendre le raccourci d'installation utilisable directement (Thunar/Xfce) ---
chmod +x /etc/skel/Desktop/installer-evoos.desktop
mkdir -p /etc/xdg/xfce4/xfconf/xfce-perchannel-xml
mkdir -p /root/Desktop
cp /etc/skel/Desktop/installer-evoos.desktop /root/Desktop/
chmod +x /root/Desktop/installer-evoos.desktop
gio set /etc/skel/Desktop/installer-evoos.desktop "metadata::trusted" true 2>/dev/null || true

# --- Support 32-bit pour Wine ---
sed -i '/\[multilib\]/,/Include/s/^#//' /etc/pacman.conf || true

# --- Locale / clavier FR (adapte si besoin) ---
sed -i 's/^#fr_FR.UTF-8/fr_FR.UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=fr_FR.UTF-8" > /etc/locale.conf
echo "KEYMAP=fr" > /etc/vconsole.conf
