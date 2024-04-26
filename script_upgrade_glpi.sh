#!/bin/sh

# --------------------------------------------------------------------------------
# Auteur : HAMEL Vincent
#
# Description :
# Script de mise à jour automatique de GLPI vers la version souhaitée.
#
# --------------------------------------------------------------------------------

# Sécurité : n'active pas le script si le repertoir config ou glpi est présent dans le mauvais répertoire
if [ -d "/var/www/html/glpi/config" ]; then
    echo "Erreur : le répertoire /var/www/glpi/config existe."
    exit 1
fi
if [ -d "/var/www/glpi" ]; then
    echo "Erreur : le répertoire /var/www/glpi existe."
    exit 1
fi

# Choix de la version souhaité
echo -n "Veuillez entrer le numero de version GLPI souhaité dans le format suivant X.X.X"
read version
echo
echo "Voulez-vous vraiment passer à la version ${version} de GLPI ? (o/n)"
read reponse
if [ "$reponse" = "o" ]; then
    echo "Mise à jour vers la version ${version}..."

    # Sauvegarde de la base de données
    echo "Sauvegarde de la base de données ..."
    echo -n "Entrez le nom de la base de données à sauvegarder: "
    echo
    read database_name
    echo -n "Entrez le mot de passe MySQL pour l'utilisateur 'root': "
    echo
    read -s password
    mysqldump -u root -p$password --databases "$database_name" > "/tmp/backup_${database_name}.sql" && echo "La sauvegarde de la base de données '$database_name' a été créée avec succès dans /tmp." || { echo "Erreur : échec de la sauvegarde de la base de données."; exit 1; }

    # Sauvegarde du répertoire plugins
    echo "Sauvegarde du répertoire plugins dans /tmp..."
    mv /var/www/html/glpi/plugins /tmp/ && echo "Sauvegarde du répertoire plugins réussie !" || { echo "Erreur : échec de la sauvegarde du répertoire plugins."; exit 1; }

    # Sauvegarde du répertoire marketplace
    echo "Sauvegarde du répertoire marketplace dans /tmp..."
    mv /var/www/html/glpi/marketplace /tmp/ && echo "Sauvegarde du répertoire marketplace réussie !" || { echo "Erreur : échec de la sauvegarde du répertoire marketplace."; exit 1; }

    # Sauvegarde du fichier downstream
    echo "Sauvegarde du fichier downstream.php dans /tmp..."
    mv /var/www/html/glpi/inc/downstream.php /tmp/ && echo "Sauvegarde du fichier downstream.php réussie !" || { echo "Erreur : échec de la sauvegarde du fichier downstream.php."; exit 1; }

    # Télécharger le dernier package GLPI depuis le dépôt officiel
    cd /var/www/html
    mv /var/www/html/glpi /tmp/glpi-bkp-$(date +%Y%m%d)
    echo "Téléchargement du répertoire glpi à jour..."
    wget https://github.com/glpi-project/glpi/releases/download/${version}/glpi-${version}.tgz && echo "Téléchargement réussi !" || { echo "Erreur : échec du téléchargement."; exit 1; }
    echo "Décompression du répertoire GLPI..."
    tar xvzf glpi-${version}.tgz && echo "Décompression réussie !" || { echo "Erreur : échec de la décompression."; exit 1; }
    rm -r glpi-${version}.tgz

    # Copier les fichiers sauvegardés depuis le répertoire temporaire
    cd /var/www/html/glpi
    rm -r files
    rm -r plugins
    rm -r marketplace
    rm -r config
    echo "Déplacement des fichiers sauvegardés dans le répertoire GLPI..."
    cp /tmp/downstream.php /var/www/html/glpi/inc/ && echo "Copie du fichier downstream.php réussi !" || { echo "Erreur : échec de la copie du fichier downstream.php."; exit 1; }
    cp -r /tmp/plugins /var/www/html/glpi/ && echo "Copie du répertoire plugins réussi !" || { echo "Erreur : échec de la copie du répertoire plugins."; exit 1; }
    cp -r /tmp/marketplace /var/www/html/glpi/ && echo "Copie du répertoire marketplace réussi !" || { echo "Erreur : échec de la copie du répertoire marketplace."; exit 1; }

    # Redémarrer le serveur Apache pour appliquer les changements
    echo "Redémarrage de GLPI..."
    systemctl restart apache2 && echo "GLPI est maintenant à jour et en ligne !" || { echo "Erreur : échec du redémarrage de GLPI."; exit 1; }

else
    echo "Mise à jour annulée."
    exit 1  # Quitte le script si l'utilisateur répond "non"
fi