#importation des données
data <- read.csv("DATA/Crime_Data_from_2020_to_Present.csv", header = TRUE, sep = ",")

#filtre des colonnes
data <- data[c("DATE.OCC", "TIME.OCC", "AREA.NAME", "Vict.Sex", "Weapon.Desc", "LAT", "LON", "Status.Desc", "Vict.Age")]

#traitement de la colonne de date

#Extraction de la date
data$DATE.OCC <-  substr(data$DATE.OCC, 1, 10)

#Extraction de l'année
data$Annee <- substr(data$DATE.OCC, 7, 10)

#Extraction du mois
data$Mois <- substr(data$DATE.OCC, 1, 2)
data$Mois <- as.numeric(data$Mois)

#Création de la colonne Saison
data$Saison <- cut(data$Mois, breaks = c(0, 3, 6, 9, 12), labels = c("Hiver", "Printemps", "Été", "Automne"))

#Création de la colonne Moment
data$Moment <- cut(data$TIME.OCC, breaks=c(0, 600, 1200, 1800, 2400), labels=c('nuit', 'matin', 'après-midi', 'soirée'))

#Traitement de la colonnes des armes
data$Weapon.Desc <- ifelse(data$Weapon.Desc %in% c("ASSAULT WEAPON/UZI/AK47/ETC", 
                                                   "HECKLER & KOCH 93 SEMIAUTOMATIC ASSAULT RIFLE",
                                                   "M-14 SEMIAUTOMATIC ASSAULT RIFLE",
                                                   "MAC-11 SEMIAUTOMATIC ASSAULT WEAPON",
                                                   "SEMI-AUTOMATIC RIFLE",
                                                   "AUTOMATIC WEAPON/SUB-MACHINE GUN",
                                                   "M1-1 SEMIAUTOMATIC ASSAULT RIFLE",
                                                   "HECKLER & KOCH 91 SEMIAUTOMATIC ASSAULT RIFLE",
                                                   "MAC-10 SEMIAUTOMATIC ASSAULT WEAPON",
                                                   "SEMI-AUTOMATIC PISTOL",
                                                   "UZI SEMIAUTOMATIC ASSAULT RIFLE"), "Armes automatiques", data$Weapon.Desc)

data$Weapon.Desc <- ifelse(data$Weapon.Desc %in% c("AIR PISTOL/REVOLVER/RIFLE/BB GUN",
                                                   "REVOLVER",
                                                   "HAND GUN"), "Armes de poing", data$Weapon.Desc)

data$Weapon.Desc <- ifelse(data$Weapon.Desc %in% c("UNKNOWN FIREARM",
                                                   "SAWED OFF RIFLE/SHOTGUN",
                                                   "ANTIQUE FIREARM",
                                                   "SHOTGUN",
                                                   "STUN GUN",
                                                   "RELIC FIREARM"), "Autres armes à feu", data$Weapon.Desc)

#Filtres des données
data <- subset(data, Annee == "2022" & 
                   (Vict.Sex == "F" | Vict.Sex == "M") & 
                   (Weapon.Desc == "Autres armes à feu" | Weapon.Desc == "Armes de poing" | Weapon.Desc == "Armes automatiques") &
                   (Vict.Age > 0))

#Modification des noms de colonnes
colnames(data)[colnames(data) == "Weapon.Desc"] <- "Arme"
colnames(data)[colnames(data) == "AREA.NAME"] <- "Lieu"
colnames(data)[colnames(data) == "TIME.OCC"] <- "Heure"
colnames(data)[colnames(data) == "DATE.OCC"] <- "Date"
colnames(data)[colnames(data) == "Vict.Sex"] <- "Sexe"
colnames(data)[colnames(data) == "Vict.Age"] <- "Age"
colnames(data)[colnames(data) == "Status.Desc"] <- "Etat"

#Modification des valeurs de la colonne Etat
data$Etat[data$Etat == "Invest Cont"] <- "En cours"
data$Etat[data$Etat == "Adult Arrest"] <- "Adulte arrêté"
data$Etat[data$Etat == "Adult Other"] <- "Adulte autres"
data$Etat[data$Etat == "Juv Arrest"] <- "Mineur arrêté"
data$Etat[data$Etat == "Juv Other"] <- "Mineur autres"