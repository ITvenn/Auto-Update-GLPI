#!/bin/sh
# Sécurité : n'active pas le script si le repertoir config est présent dans le mauvais répertoire
if [ -d "/var/www/glpi/config" ]; then
    echo "Erreur : le répertoire /var/www/glpi/config existe."
    exit 1
fi
echo "Sauvegarde de la base de données ..."
echo -n "Entrez le nom de la base de données à sauvegarder: "
read database_name
echo -n "Entrez le mot de passe MySQL pour l'utilisateur 'root': "
read -s password
echo
# Exécute la commande mysqldump pour sauvegarder la base de données spécifiée
mysqldump -u root -p$password --databases "$database_name" > "/tmp/backup_${database_name}_glpi.sql" && echo "La sauvegarde de la base de données '$database_name' a été créée avec succès dans /tmp." || { echo "Erreur : échec de la sauvegarde de la base de données."; exit 1; }

echo "Sauvegarde du répertoire plugins dans /tmp..."
mv /var/www/html/glpi/plugins /tmp/ && echo "Sauvegarde du répertoire plugins réussie !" || { echo "Erreur : échec de la sauvegarde du répertoire plugins."; exit 1; }
echo "Sauvegarde du répertoire marketplace dans /tmp..."
mv /var/www/html/glpi/marketplace /tmp/ && echo "Sauvegarde du répertoire marketplace réussie !" || { echo "Erreur : échec de la sauvegarde du répertoire marketplace."; exit 1; }
echo "Sauvegarde du fichier downstream.php dans /tmp..."
mv /var/www/html/glpi/inc/downstream.php /tmp/ && echo "Sauvegarde du fichier downstream.php réussie !" || { echo "Erreur : échec de la sauvegarde du fichier downstream.php."; exit 1; }
cd /var/www/html
echo "Téléchargement du répertoire glpi à jour..."
wget https://github.com/glpi-project/glpi/releases/download/10.0.15/glpi-10.0.15.tgz && echo "Téléchargement réussi !" || { echo "Erreur : échec du téléchargement."; exit 1; }
echo "Décompression du répertoire GLPI..."
tar xvzf glpi-10.0.15.tgz && echo "Décompression réussie !" || { echo "Erreur : échec de la décompression."; exit 1; }
rm -r glpi-10.0.15.tgz
rm -r /var/www/html/glpi
mv /var/www/html/glpi-* /var/www/html/glpi
cd /var/www/html/glpi
rm -r files
rm -r plugins
rm -r marketplace
rm -r config
echo "Déplacement des fichiers sauvegardés dans le répertoire GLPI..."
cp /tmp/downstream.php /var/www/html/glpi/inc/ && echo "Copie du fichier downstream.php réussi !" || { echo "Erreur : échec de la copie du fichier downstream.php."; exit 1; }
cp /tmp/plugins /var/www/html/glpi/ && echo "Copie du répertoire plugins réussi !" || { echo "Erreur : échec de la copie du répertoire plugins."; exit 1; }
cp /tmp/marketplace /var/www/html/glpi/ && echo "Copie du répertoire marketplace réussi !" || { echo "Erreur : échec de la copie du répertoire marketplace."; exit 1; }
echo "Redémarrage de GLPI..."
systemctl restart apache2 && echo "GLPI est maintenant à jour et en ligne !" || { echo "Erreur : échec du redémarrage de GLPI."; exit 1; }