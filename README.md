# Script de mise à jour automatique de GLPI vers la version souhaitée.

Ce script automatise le processus de mise à jour de GLPI à la version souhaitée. Il gère la sauvegarde des composants essentiels (Base de données) et l'installation vers la version sélectionnée.

## Fonctionnalités

- Sauvegarde automatique des plugins, du marché et des configurations.
- Sauvegarde de la base de données
- Téléchargement et installation de la nouvelle version de GLPI.
- Restauration des fichiers sauvegardés et redémarrage du service Apache.

## Prérequis

- Un serveur web avec GLPI déjà installé.
- Répertoire GLPI dans /var/www/html/glpi sinon adapter le script à votre répertoire
- Accès SSH au serveur.
- Droits d'administrateur ou de superutilisateur.
- wget et tar installés sur le serveur.

## Installation

1. Téléchargez le script sur votre serveur où GLPI est installé.
2. Assurez-vous que le script est exécutable :
   ```bash
   chmod +x script_upgrade_glpi.bash
   ```

## Utilisation

Pour lancer la mise à jour de GLPI, exécutez simplement le script :
```bash
./script_upgrade_glpi.bash
```

Le script effectuera les opérations suivantes :
- Sauvegarde des répertoires `plugins` et `marketplace`, ainsi que du fichier `downstream.php`.
- Sauvegarde de la base de données
- Téléchargement et extraction de la nouvelle version de GLPI.
- Suppression des anciens répertoires de GLPI et remplacement par les nouveaux.
- Restauration des fichiers sauvegardés.
- Redémarrage d'Apache pour appliquer les changements.
- Suppression du script.

## Sécurité

Vérifiez toujours les scripts shell avant de les exécuter pour éviter les problèmes de sécurité inattendus. Assurez-vous que les sources de téléchargement sont fiables. N'oubliez pas de faire une snapshot !!!

## Contribution

Les suggestions et contributions sont bienvenues via des issues sur le dépôt GitHub associé à ce projet.

## Licence

Ce projet est distribué sous la licence MIT, permettant une utilisation libre dans les limites définies par cette licence.

## Support

Pour toute question ou problème, n'hésitez pas à soumettre une issue sur le dépôt GitHub du projet.

Ce script offre une base solide que tu peux personnaliser selon les spécificités de ton environnement ou tes préférences personnelles. Assure-toi de tester le script dans un environnement de développement ou de test avant de l'exécuter en production pour éviter tout impact inattendu.
