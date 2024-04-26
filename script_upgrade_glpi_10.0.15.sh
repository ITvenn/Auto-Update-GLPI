#!/bin/sh
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