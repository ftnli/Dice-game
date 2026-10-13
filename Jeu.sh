#!/bin/bash

# création de la fonction qui teste si un joueur a gagné la partie en mode multijoueur
aucun_gagnant() {

	for i in $(seq 0 $((n-1)))
	do
		if [ "${combinaisons[$i]}" -eq 3 ]
		then
			return 1 # on a trouvé un gagnant
		fi
	done
	return 0 # il n'y a pas encore de gagnant
}

while true
do

	# initialisation des variables pour les dés et initialisation du compteur des tours
	tours=0
	d1=0
	d2=0
	d3=0
	
	# affichage du menu du jeu et choix du mode de jeu
	echo
	echo -e "\033[38;5;205mBienvenue dans le menu principal du jeu de dé\033[0m"
	sleep 0.5
	echo
	echo "Veuillez selectionner un mode de jeu. "
	
	while true
	do
		echo "Entrez S pour jouer en mode solo, entrez M pour jouer en multijoueur : "
		read mode
		echo
		sleep 0.5
		
		if [ "$mode" = "S" ] || [ "$mode" = "s" ]
		then
			echo -e "\033[38;5;209mMode solo sélectionné.\033[0m"
			mode="S"
			break
			
		elif [ "$mode" = "M" ] || [ "$mode" = "m" ]
		then 
			echo -e "\033[38;5;209mMode multijoueur sélectionné.\033[0m"
			mode="M"
			break
			
		else
			echo -e "\033[93mChoix invalide\033[0m"
			echo 
		fi
	done
	
	echo
	
	# jeu en mode solo
	if [ "$mode" = "S" ] 
	then
	
		# on utilise de simples variables pour stocker les combinaisons
		tris=0
		paire=0
		echelle=0
		
		# annonce le début de la partie
		echo -e "\033[38;5;141mLe jeu de dés va commencer.\033[0m"
		echo
		sleep 1
	
		# boucle principale du jeu
		while [ "$tris" -eq 0 ] || [ "$paire" -eq 0 ] || [ "$echelle" -eq 0 ]
		do
			tours=$((tours + 1))
		
			d1=$((RANDOM % 6 + 1))
			d2=$((RANDOM % 6 + 1))
			d3=$((RANDOM % 6 + 1))
		
			echo "$d1 $d2 $d3"
		
			# partie tests des combinaisons 
			# test des tris
			if [ "$d1" -eq "$d2" ] && [ "$d2" -eq "$d3" ] 
			then
				if [ "$tris" -eq 0 ] 
				then
					echo -e "\033[96mVous avez obtenu un tris !\033[0m"
					tris=1
				elif [ "$paire" -eq 0 ]
				then
					echo -e "\033[96mVous avez obtenu une paire !\033[0m"
					paire=1
				fi
		
			# test des paires
			elif [ "$d1" -eq "$d2" ] || [ "$d2" -eq "$d3" ] || [ "$d1" -eq "$d3" ]
			then
				if [ "$paire" -eq 0 ]
				then
					echo -e "\033[96mVous avez obtenu une paire !\033[0m"
					paire=1
				fi
			
			# test des echelles, si on arrive ici les trois valeurs obtenues sont distinctes
			else
				# on cherche la plus petite valeur obtenue parmi les 3 dés
				rmin=$d1
				if [ "$d2" -lt "$rmin" ]
				then
					rmin=$d2
				fi
				if [ "$d3" -lt "$rmin" ] 
				then
					rmin=$d3
				fi
			
				# on cherche la plus grande valeur obtenue parmi les 3 dés
				rmax=$d1
				if [ "$d2" -gt "$rmax" ]
				then
					rmax=$d2
				fi
				if [ "$d3" -gt "$rmax" ] 
				then
					rmax=$d3
				fi
			
				# on regarde si on a obtenu 3 valeurs rmin,di,rmax avec rmax=rmin+2 
				t=$((rmin + 2))
				# si rmax=rmin+2 on a forcément di=rmin+1 car rmin<di<rmax par construction
				if [ "$rmax" -eq "$t" ]
				then
					if [ "$echelle" -eq 0 ]
					then
						echo -e "\033[96mVous avez obtenu une échelle !\033[0m"
						echelle=1
					fi
				fi
			fi
		
			#tris=1
			#paire=1
			#echelle=1
		
			echo
			sleep 0.5
	
		done
	
		# si on arrive ici on a coché les trois combinaisons, la partie est terminée
		echo -e "\033[38;5;141mPartie terminée en $tours tour(s) !\033[0m"
		echo
	
	
		
	# jeu en mode multijoueur
	else
		
		echo "Entrez le nombre de joueurs : "
		
		while true
		do
			read n
			echo
			
			if [ "$n" = "" ]
			then
				echo -e "\033[93mEntrez un nombre entier strictement supérieur à 1 : \033[0m"
				echo
				
			elif [ "${n//[0-9]/}" != "" ] || [ "$n" -le 1 ]
			then
				echo -e "\033[93mEntrez un nombre entier strictement supérieur à 1 : \033[0m"
				echo 
				
			else
				echo -e "\033[38;5;209mVous avez choisi $n joueurs.\033[0m"
				echo
				break
			fi
			
		done
		
		# on utilise des tableaux pour stocker le nom des joueurs et les combinaisons à cocher pour chaque joueur
		declare -a joueurs
		declare -a combinaisons
		declare -a tris
		declare -a paires
		declare -a echelles
		
		
		
		# initialisation des tableaux joueurs et combinaisons 
		for i in $(seq 0 $((n-1)))
		do
			tris[$i]=0
			paires[$i]=0
			echelles[$i]=0
			combinaisons[$i]=0
			
			echo "Entrez le prénom du joueur $((i+1)) : "
			read prenom
			echo
			
			joueurs[$i]="$prenom"
			
		done
		
		# annonce le début de la partie
		echo -e "\033[38;5;141mLe jeu de dés va commencer.\033[0m"
		echo
		sleep 1
		
		# boucle principale du jeu 
		while aucun_gagnant
		do 
			tours=$((tours + 1))
			echo -e "\033[38;5;205mTour $tours : \033[0m"
			echo
			
			for i in $(seq 0 $((n-1)))
			do
				d1=$((RANDOM % 6 + 1))
				d2=$((RANDOM % 6 + 1))
				d3=$((RANDOM % 6 + 1))
		
				echo "${joueurs[$i]} a fait : $d1 $d2 $d3"
				
				# partie tests des combinaisons 
				# test des tris
				if [ "$d1" -eq "$d2" ] && [ "$d2" -eq "$d3" ] 
				then
					if [ "${tris[$i]}" -eq 0 ] 
					then
						echo -e "\033[96m${joueurs[$i]} a obtenu un tris !\033[0m"
						tris[$i]=1
						combinaisons[$i]=$((combinaisons[$i]+1))
						
					elif [ "${paires[$i]}" -eq 0 ]
					then
						echo -e "\033[96m${joueurs[$i]} a obtenu une paire !\033[0m"
						paires[$i]=1
						combinaisons[$i]=$((combinaisons[$i]+1))
						
					fi
		
				# test des paires
				elif [ "$d1" -eq "$d2" ] || [ "$d2" -eq "$d3" ] || [ "$d1" -eq "$d3" ]
				then
					if [ "${paires[$i]}" -eq 0 ]
					then
						echo -e "\033[96m${joueurs[$i]} a obtenu une paire !\033[0m"
						paires[$i]=1
						combinaisons[$i]=$((combinaisons[$i]+1))
					fi
			
				# test des echelles, si on arrive ici les trois valeurs obtenues sont distinctes
				else
					# on cherche la plus petite valeur obtenue parmi les 3 dés
					rmin=$d1
					if [ "$d2" -lt "$rmin" ]
					then
						rmin=$d2
					fi
					if [ "$d3" -lt "$rmin" ] 
					then
						rmin=$d3
					fi
			
					# on cherche la plus grande valeur obtenue parmi les 3 dés
					rmax=$d1
					if [ "$d2" -gt "$rmax" ]
					then
						rmax=$d2
					fi
					if [ "$d3" -gt "$rmax" ] 
					then
						rmax=$d3
					fi
			
					# on regarde si on a obtenu 3 valeurs rmin,di,rmax avec rmax=rmin+2 
					t=$((rmin + 2))
					# si rmax=rmin+2 on a forcément di=rmin+1 car rmin<di<rmax par construction
					if [ "$rmax" -eq "$t" ]
					then
						if [ "${echelles[$i]}" -eq 0 ]
						then
							echo -e "\033[96m${joueurs[$i]} a obtenu une échelle !\033[0m"
							echelles[$i]=1
							combinaisons[$i]=$((combinaisons[$i]+1))
							
						fi
					fi
				fi
				
				if [ "${combinaisons[$i]}" -eq 3 ]
				then 
					echo
					g=$i
					break
				fi
				
				echo
				sleep 0.5
			
			done
		
		done
		
		# si on arrive ici alors l'un des joueurs a gagné
		
		echo -e "\033[38;5;141mLe joueur $((g+1)) : ${joueurs[$g]} a gagné en $tours tours ! Bravo !\033[0m"
		echo
		
	fi
	
	echo "Voulez vous rejouer ?"
	
	while true
	do
	
		echo "Entrez O pour oui ou N pour non : "
		read rep
		
		
		if [ "$rep" = "N" ] || [ "$rep" = "n" ]
		then
			rep="N"
			break
			
		elif [ "$rep" = "O" ] || [ "$rep" = "o" ]
		then
			rep="O"
			break
		else
			echo
			echo -e "\033[93mChoix invalide\033[0m"
			echo 
		fi
	done
	
	if [ "$rep" = "N" ]
	then
		echo 
		echo -e "\033[38;5;205mÀ bientôt !\033[0m"
		echo
		break
	fi

done