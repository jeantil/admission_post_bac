# Admission post-bac

Code source d'Admission post-bac envoyé par le ministère de l'Education
nationale

Code source publié
---
En [PDF](http://api.rue89.nouvelobs.com/sites/news/files/assets/document/2016/10/algorithme.pdf) qui contient un scan du code imprimé parcequ'on est en 2016
Article sur rue 89 :  http://tempsreel.nouvelobs.com/rue89/rue89-nos-vies-connectees/20161018.RUE4061/voici-le-code-source-d-admission-post-bac-qu-ont-recu-les-lyceens.html


Comprendre l'algorithme
---
Selon les commentaires laissés sur mon gist initial:

Pour ceux qui veulent vérifier que l'algo est complet : [PDF ](http://api.rue89.nouvelobs.com/sites/news/files/assets/document/2016/10/algorithme.pdf)
----
**Ces commentaires (RUE89) peuvent aider à la compréhension :**

[#1]

> après une lecture très rapide je m’étonne qu’on ne trouve pas de ligne DBMS_RANDOM.seed (j’ai pu passer à coté). Ça m’embête : quand on veut générer des données aléatoires il vaut mieux modifier la graine du générateur avec une donnée susceptible de changer d’un test à l’autre sinon on va générer les mêmes données (soit disant aléatoire) à chaque appel ...
>
> Après il faut une connaissance fine des différents types de candidats (AEFE, EFE, FNS, IDF ...) pour comprendre dans quel ordre sont fait les classements, il y a quelques commentaires qui aident (les lignes qui commencent par « – »). Si vous êtes dans le groupe « réo-néeo » visiblement vous êtes mal traité et il y aura des modifications à faire !
>
> A noter la phrase « on n'est pas en base de prod » qui apparaît page 8, le début du code correspond donc peut être à une fonction pour tester la répartition probablement des candidats (ça se fait sur certains concours) ensuite il y a une partie noté « en production ».

[#2]

> Probablement les « Réorientations » pour réo-néeo. Les bacheliers de l’année sont prioritaires (c’est assumé) par rapport aux réorientations.
> J'ai du mal à déduire de cet algo la structure de la BDD... l'idéal serait d'avoir un jeu de donnée (évidement fake pour respecter l’anonymat des users présent en base)
>
> Je pense qu'il faudrait réclamer la structure de la base de donnée, commentée de manière claire.

[#3]

> En deux mots, il faut que l’éducation nationale envoie aussi la signification des variables d’entrées (ce qu’il y entre FUNCTION et RETURN NUMBER IS) et la traduction de champs utilisés (tout ce qui à la forme : c_fr_cod, g_fr_truc...)

par @inattendu

> Je viens de trouver ça également: https://github.com/arnaudriegert/comprendre-apb. Il y a notamment un PDF qui décrit l'algo, ca peut peut-être aider.

@piwai
