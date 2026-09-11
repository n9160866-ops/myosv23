# EvoOS — profil archiso personnalisé

Base : Arch Linux + Xfce + WiFi (NetworkManager) + Wine (compat apps Windows x86_64)

## Prérequis (sur une machine Arch Linux, PAS dans ce zip)

```bash
sudo pacman -S --needed archiso
```

## Compilation de l'ISO

1. Dézippe ce fichier, par exemple dans `~/evoos`
2. Lance le build :

```bash
cd ~/evoos
sudo mkarchiso -v -o out/ .
```

3. L'ISO sera générée dans `out/evoos-<date>-x86_64.iso`

## Compiler via GitHub Actions (sans machine Arch)

Le fichier `.github/workflows/build.yml` est déjà inclus.

1. Crée un dépôt GitHub et pousse ce dossier dedans :

```bash
cd evoos
git init
git add .
git commit -m "Initial EvoOS archiso profile"
git branch -M main
git remote add origin https://github.com/<ton-user>/<ton-repo>.git
git push -u origin main
```

2. Va dans l'onglet **Actions** du dépôt → le workflow "Build EvoOS ISO" se lance automatiquement au push (ou clique sur **Run workflow** pour le lancer manuellement).
3. Une fois le build terminé (~15-30 min selon les serveurs), l'ISO est disponible en téléchargement dans l'onglet **Actions → [le run] → Artifacts**, en bas de page.

⚠️ Le build tourne dans un conteneur `archlinux:latest` avec `--privileged` (nécessaire pour `mkarchiso`/squashfs). Les runners GitHub gratuits ont une limite de 6h et ~14 Go d'espace disque, largement suffisant ici.

## Expérience "premier démarrage" (installeur graphique)

EvoOS inclut **Calamares**, l'installeur graphique utilisé par Manjaro/EndeavourOS. Depuis le bureau live (Xfce), une icône **"Installer EvoOS"** est présente sur le Bureau.

Séquence de l'installeur (comme un vrai OS) :
1. **Bienvenue** — présentation, vérifications (RAM, espace disque)
2. **Langue / région** — fuseau horaire, langue système
3. **Clavier** — disposition (FR par défaut)
4. **Partitionnement** — effacer le disque / manuel / à côté d'un autre OS
5. **Utilisateur** — nom, mot de passe, nom de la machine
6. **Résumé** — récap avant de lancer l'installation
7. **Installation** — copie du système + config (bootloader GRUB, réseau, etc.)
8. **Terminé** — redémarrage sur le système installé

Config Calamares dans `airootfs/etc/calamares/` :
- `settings.conf` — séquence des écrans
- `modules/*.conf` — un fichier par écran (locale, keyboard, users, partition...)
- `branding/evoos/` — logo, nom "EvoOS", couleurs affichées dans l'installeur

Pour personnaliser le logo affiché pendant l'installation, remplace `airootfs/etc/calamares/branding/evoos/evoos.png`.

## Tester l'ISO (QEMU)

```bash
qemu-system-x86_64 -m 4096 -enable-kvm -cdrom out/evoos-*.iso
```

## Identifiants par défaut

- Utilisateur live : `evoos` / mot de passe `evoos`
- Root : mot de passe `evoos`

**Change ces mots de passe avant toute utilisation réelle** (fichier `airootfs/root/customize_airootfs.sh`).

## Ce qui est inclus

- Xfce (interface graphique + Thunar comme explorateur de fichiers)
- NetworkManager + iwd/wpa_supplicant → gestion WiFi complète (applet réseau dans la barre)
- Wine + winetricks + support 32-bit (multilib) → exécution d'applications Windows x86_64
- Firefox, gestionnaire d'archives, GParted, outils système de base
- SSH activé par défaut (pense à le désactiver si tu ne t'en sers pas)

## Personnaliser

- **Ajouter/retirer des paquets** → édite `packages.x86_64`
- **Config utilisateur, services** → édite `airootfs/root/customize_airootfs.sh`
- **Nom de l'ISO / label** → édite `profiledef.sh`
- Pour ajouter des fichiers de config directement dans le système final (fond d'écran, .config, etc.), place-les dans `airootfs/` en respectant l'arborescence du système (ex : `airootfs/etc/skel/.config/...`)

## Limites de Wine à connaître

Wine ≠ machine virtuelle : c'est une couche de traduction d'API Windows→Linux.
- Logiciels bureautiques / outils simples : généralement OK
- Jeux avec anti-cheat (EAC, BattlEye) ou fort DRM : souvent problématiques
- Vérifie la compatibilité au cas par cas sur https://appdb.winehq.org

Alternative si tu as besoin d'une vraie compatibilité Windows complète : intégrer **QEMU/KVM** en plus pour lancer une VM Windows classique (mais ce n'est plus "natif").
