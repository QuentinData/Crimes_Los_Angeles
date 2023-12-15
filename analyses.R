# Importation

source(file = "global.r")

# Consolidation

intervalle <- cut(la$TIME.OCC, breaks=c(0, 600, 1200, 1800, 2400), labels=c('nuit', 'matin', 'après-midi', 'soirée'))
la$moment <- intervalle

la$num_mois <- substr(la$DATE.OCC, 1, 2)
la$année <- substr(la$DATE.OCC, 7, 10)

# Nettoyage des données

la_h <- la %>% 
  select(DR_NO, DATE.OCC, AREA.NAME, Crm.Cd.Desc, Mocodes, Vict.Age, Vict.Sex, 
         Premis.Desc, Weapon.Desc, Status.Desc, moment, num_mois, année) %>%
  separate_rows(Mocodes, sep = " ") %>%
  filter(Mocodes == 1218 | Mocodes == 2004)

# Dataset Victim Homeless

homeless_v <- la_h %>%
  filter (Mocodes == 1218)

# Dataset Suspect Homeless

homeless_s <- la_h %>%
  filter (Mocodes == 2004)

# Nombre homeless case

homeless_case <- la_h %>%
  group_by(DR_NO) %>%
  summarise(nb = n())

nb_homeless_case <- nrow(homeless_case)

# Nombre de victim homeless case

nb_victim_case <- sum(la_h$Mocodes == 1218, na.rm = TRUE)

# Nombre de suspect homeless case

nb_suspect_case <- sum(la_h$Mocodes == 2004, na.rm = TRUE)

# Nombre de between homless case

nb_between_case <- 8389

# Graph victim

#Diagramme pour étudier le nombre de homeless victim par quartier


ggplot(homeless_v, aes(x = AREA.NAME)) +
  geom_bar(fill = "skyblue", color = "black") +
  labs(title = "Nombre de victimes Sans-abri par Ville",
       x = "Ville",
       y = "Nombre de victimes") +
  theme_minimal()


#Diagramme pour savoir la répartition des victimes par saison

# Convertir la colonne DATE.OCC au format de date et heure
homeless_v$DATE.OCC <- as.POSIXct(homeless_v$DATE.OCC, format="%m/%d/%Y %I:%M:%S %p")

# Ajouter une colonne pour le mois
homeless_v$Mois <- as.numeric(format(homeless_v$DATE.OCC, "%m"))

# Ajouter une colonne pour les saisons
homeless_v$Saison <- cut(homeless_v$Mois, breaks = c(0, 3, 6, 9, 12), labels = c("Hiver", "Printemps", "Été", "Automne"))

