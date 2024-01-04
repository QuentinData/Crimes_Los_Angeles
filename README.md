# Crimes Los Angeles

## Introduction
L'application "Crimes par Armes à Feu à Los Angeles en 2022" offre la possibilité d'approfondir ses connaissances sur les crimes impliquant des armes à feu dans la ville de Los Angeles.

Voici un aperçu de l'application : 

<img width="1440" alt="apercu" src="[https://github.com/QuentinData>](https://github.com/QuentinData/Crimes_Los_Angeles/blob/main/apercu.png)


## Comment exécuter l'application
- Avoir R et R studio sur votre machine
- Télécharger le projet depuis le [Répository R-Shiny](https://github.com/QuentinData/Crimes_Los_Angeles)
- Télécharger le jeu de données via ce lien [Crime-Data](https://data.lacity.org/Public-Safety/Crime-Data-from-2020-to-Present/2nrs-mtv8/about_data)
- Mettre le fichier dans un dossier DATA que vous créez
- Ouvrir global.R, packages.R et Webapp_DataCrime.R
- Modifier les chemins (1 sur global.R avec l'endroit où est placé le jeu de donées et 2 sur Webapp_DataCrime.R avec l'endroit où est placé le fichier packages et de même pour le fichier global)
- Aller sur app.R et appuyez sur Run App pour lancer l'application. 
  

## Les onglets de l'Application

### Onglet "Données Initiales"
Cet onglet présente la table de données sur laquelle l'application est construite. Cela vous permettra d'avoir une vue d'ensemble des données disponibles.

### Onglet "Résumé"
Pour faire fonctionner l'onglet "Résumé" et tous les suivants, il est nécessaire de sélectionner au moins une proposition dans chaque filtre pour que les tableaux de résumé puissent être générés.

### Onglet "Repartition des états"
L'onglet "Répartition des États" met en évidence le statut des affaires sélectionnées, indiquant si elles ont été résolues ou si elles sont toujours en cours.

### Onglet "Distribution des âges"
En sélectionnant les filtres souhaités, un graphique présente la distribution des âges des crimes sélectionnés.

### Onglet "Carte Interactive"
Sur la carte s'affichent les crimes sélectionnés.


## Remarques 
Il est nécessaire de sélectionner au moins une proposition dans chaque filtre pour générer des visuels.
