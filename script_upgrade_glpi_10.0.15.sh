#!/bin/sh
echo "Sauvegarde de la base de données ..."

# Demande à l'utilisateur le nom de la base de données
echo -n "Entrez le nom de la base de données à sauvegarder: "
read database_name

# Demande à l'utilisateur de saisir le mot de passe de manière sécurisée
echo -n "Entrez le mot de passe MySQL pour l'utilisateur 'root': "
read -s password
echo

# Exécute la commande mysqldump pour sauvegarder la base de données spécifiée
mysqldump -u root -p$password --databases "$database_name" > "/tmp/backup_${database_name}_glpi.sql" && echo "La sauvegarde de la base de données '$database_name' a été créée avec succès dans /tmp."

echo "Sauvegarde du répertoire plugins dans /tmp..."
mv /var/www/html/glpi/plugins /tmp/ && echo "Sauvegarde du répertoire plugins réussie !"
echo "Sauvegarde du répertoire marketplace dans /tmp..."
mv /var/www/html/glpi/marketplace /tmp/ && echo "Sauvegarde du répertoire marketplace réussie !"
echo "Sauvegarde du fichier downstream.php dans /tmp..."
mv /var/www/html/glpi/inc/downstream.php /tmp/ && echo "Sauvegarde du fichier downstream.php réussie !"
cd /var/www/html
echo "Téléchargement du répertoire glpi à jour..."
wget https://github.com/glpi-project/glpi/releases/download/10.0.15/glpi-10.0.15.tgz && echo "Téléchargement réussi !"
echo "Décompression du répertoire GLPI..."
tar xvzf glpi-10.0.15.tgz && echo "Décompression réussie !"
rm -r glpi-10.0.15.tgz
rm -r /var/www/html/glpi
mv /var/www/html/glpi-* /var/www/html/glpi
cd /var/www/html/glpi
rm -r files
rm -r plugins
rm -r marketplace
rm -r config
echo "Déplacement des fichiers sauvegardés dans le répertoire GLPI..."
cp /tmp/downstream.php /var/www/html/glpi/inc/ && echo "Copie du fichier downstream.php réussi !"
cp /tmp/plugins /var/www/html/glpi/ && echo "Copie du répertoire plugins réussi !"
cp /tmp/marketplace /var/www/html/glpi/ && echo "Copie du répertoire marketplace réussi !"
echo "Redémarrage de GLPI..."
systemctl restart apache2 && echo "GLPI est maintenant à jour et en ligne !"
