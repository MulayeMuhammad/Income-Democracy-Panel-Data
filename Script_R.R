##  Charger les bibliothèques nécessaires 
library(readxl)  # Pour lire les fichiers Excel
install.packages("tidyverse")  # Installer tidyverse si nécessaire
library(tidyverse)  # Charger tidyverse pour des manipulations de données avancées
library(ggplot2)  # Pour la visualisation
library(plm)  # Pour les modèles de données de panel
library(pder)  # Pour les données d'exemple et les fonctions associées
library(pgmm)  # Pour les modèles dynamiques GMM

# Charger les données
data1 <- read_excel("C:/Users/hp/Downloads/data2.xlsx")

# ---- Figure 1: Relation entre le PIB par habitant et la démocratie ----

# Visualisation avec ggplot2
ggplot(data1, aes(x = lrgdpch, y = fhpolrigaug, label = code)) +
  geom_point(size = 0) +  # Points non visibles (équivaut à msymbol(none))
  geom_text(size = 3) +  # Ajouter les étiquettes des codes pays
  geom_smooth(method = "lm", se = FALSE, color = "black") +  # Ajustement linéaire
  scale_x_continuous(name = "Log PIB par habitant", limits = c(6, 10.6)) +  # Échelle de l'axe X
  scale_y_continuous(name = "Freedom House Measure of Democracy") +  # Échelle de l'axe Y
  theme_minimal() +  # Thème minimaliste
  theme(legend.position = "none")  # Supprimer la légende

# ---- Analyse des données de panel ----

# Charger les données intégrées
data("DemocracyIncome", package = "pder")

# Les données quinquennales constituent un panel équilibré 
#de 211 pays observés sur 11 périodes. Toutefois, cet équilibre 
#est artificiel car de nombreuses observations sont manquantes, 
#notamment en ce qui concerne les niveaux de démocratie. 
#Les données comprennent les deux indices individuels et temporels 
#(pays et année), l'indice de démocratie democracy, le logarithme 
#du revenu du produit intérieur brut par habitant, et enfin, un indicateur 
#permettant de sélectionner le sous-ensemble considéré par l'échantillon 
#des auteurs.



 # Modèle OLS (Pooling)

# Dans le modèle, la variable dépendante est l'indice de démocratie, 
#et les régresseurs sont les retards d'une période de l'indice de 
#démocratie lui-même et du revenu par habitant. L'estimation des ols 
#par la fonction R lm est faussée par la présence de valeurs retardées. 
#En fait, la méthode lagm utilisée par le programme sera celle appropriée 
#pour les séries temporelles, et non celle pour les données de panel. 
#Pour cette raison, la fonction plm dans le package plm sera utilisée à 
#la place, en fixant l'argument du modèle à 'pooling', conservant ainsi l
#es données non transformées. Le -1 dans la formule indique que nous ne 
#voulons pas estimer une constante générale mais un coefficient pour 
#toutes les instances de la variable année, ce qui n'affecte pas l'estimation.

ols <- plm(
  democracy ~ lag(democracy) + lag(income) + year - 1,
  data = DemocracyIncome, index = c("country", "year"),
  model = "pooling", subset = sample == 1
)
summary(ols)

#Le même modèle peut être estimé en réglant le modèle sur « within » 
# et l'effet sur « time » :

#  Modèle Within (Effet fixe temporel)
ols <- plm(
  democracy ~ lag(democracy) + lag(income),
  data = DemocracyIncome, index = c("country", "year"),
  model = "within", effect = "time",
  subset = sample == 1
)
summary(ols)



# Le modèle within est obtenu avec plm en fixant les arguments du modèle 
#et de l'effet à « within » et « twoways », puisque nous voulons introduire 
#des effets individuels et temporels. Le modèle peut être simplement 
#estimé en mettant à jour le modèle ols précédent :

# Modèle Within (Effet fixe temporel et individuel)

within <- update(ols, effect = "twoways")
summary(within)




# Pour calculer l'estimateur d'Anderson et Hsiao (1982), il faut spécifier 
#que le régresseur et les régresseurs sont différenciés et que la variable 
#endogène retardée en différences est instrumentée avec la variable 
#endogène en niveaux retardée de deux périodes. Le modèle est simplement 
#décrit à l'aide d'une formule en deux parties, la première partie indiquant 
#les variables explicatives et la seconde les instruments, les deux 
#parties étant séparées par le signe |.

# Modèle d'Anderson-Hsiao (Différences premières)
ahsiao <- plm(diff(democracy) ~ lag(diff(democracy)) +
                lag(diff(income)) + year - 1 |
                lag(democracy, 2) + lag(income, 2) + year - 1,
              DemocracyIncome, index = c("country", "year"),
              model = "pooling", subset = sample == 1)
coef(summary(ahsiao))[1:2,]


# L'estimation gmm d'un modèle de panel est réalisée par la fonction pgmm 
#de la bibliothèque plm. Les arguments de cette fonction sont les mêmes 
#que ceux de la fonction plm, plus quelques arguments spécifiques :
# - formula : la formule est particulière, car elle comporte trois parties : la première, comme d'habitude, contient les variables explicatives, la deuxième les instruments « gmm », la troisième les instruments « normaux »,
# - modèle : le modèle à estimer, soit en une étape : « onestep », soit en deux étapes : « twosteps »,
# - effet : les effets sont soit « individuels » (ils sont alors éliminés par différenciation), soit « twoways », auquel cas des variables indicatrices pour chaque période sont ajoutées en tant qu'instruments « normaux ».
# Nous calculons d'abord l'estimateur à une étape :

# Modèle GMM à une étape
diff1 <- pgmm(democracy ~ lag(democracy) + lag(income) |
                lag(democracy, 2:99)| lag(income, 2),
              DemocracyIncome, index=c("country", "year"),
              model="onestep", effect="twoways", subset = sample == 1)
summary(diff1)

# Le modèle à deux étapes est obtenu en fixant l'argument du modèle à « twosteps » :

# Modèle GMM à deux étapes
diff2 <- update(diff1, model = "twosteps")
summary(diff2)



# Test AR(2) pour la corrélation des erreurs
mtest(diff1, order = 2)
       
# Test de Sargan pour les restrictions de sur-identification
sargan(diff1)
