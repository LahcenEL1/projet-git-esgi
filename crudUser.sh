#!/bin/bash
#~ clear
clear

#**************************************************************#
#                                                              #
#                   EL OUARDI Lahcen                           #
#**************************************************************#

#**************************************************************#                
#                       FONCTION : --help                      #
usage() {
    echo -e "usage : ./crudUser.sh [OPTION]...\n"
    echo -e "Crud a User"
    echo -e "OPTIONS
    --help            show help and exit
    -a 'Name of file'   Add a file which content a list of user
    \n "

}

#**************************************************************#
#                       CHECK OPTION --help                    #
print_usage()
{
    if (test "$1" = "--help") && [ $# -eq 1 ]; then
        usage
        exit 0
    fi

}
#**************************************************************#
#     FONCTION : VERIFICATION DE LA VALIDITE DES ARGUMENTS     #
verif_options() {
    print_usage $*
    if [ $# -ne 0 ]; then
        echo "ERROR : Many argument" >&2
        echo "use : --help for more information" >&2
        exit 1
    fi
        
    echo "SUCCESS : valid options\n"
}


#**************************************************************#
#                       MENU                                   #
displayMenu()
{
    echo -e "Crud User \n"
    echo -e "Ajout d’un utilisateur : Taper 1"
    echo -e "Modification d’un utilisateur: Taper 2"
    echo -e "Suppression d’un utilisateur : Taper 3"
    echo -e "Sortie du script : Taper 4\n\n"
    read -p "Choix:du menu " valueMenu
    while [[ "$valueMenu" != [1-4] ]]  ; do
        read -p " Error: veuillez tape un chiffre entre 1 et 4 :  " valueMenu
        echo $valueMenu
    done
    
    if [ $valueMenu -eq 1 ];then
        createUser
    fi
    if [ $valueMenu -eq 2 ];then
        displayUpdate
    fi
    if [ $valueMenu -eq 3 ];then
        deleteUser
    fi
    if [ $valueMenu -eq 4 ];then
        exitMenu
    fi
}

#**************************************************************#
#                       Exit MENU   4                          #
exitMenu()
{
    exit 0; 
    echo -e " if you want to restart the programm, execute the script"
}



#**************************************************************#
#                       Create USer   1                        #
createUser()
{
    
    echo -e " Creation d'un utlisateur"
    echo " Veuillez remplir le formulaire ci desous
    "
    read -p "   Nom de l'utilisateur : " nameUser
    while [ -z "$nameUser" ]; do 
        echo -e "Nom de l'utilisateur est vide, Ecrivez un Nom d'utilisateur correct:">&2
        read -p "   Nom de l'utilisateur : " nameUser
    done
    cheminDefault="/home/$nameUser"
    read -e -i "$cheminDefault" -p "   Chemin du dossier en commencant par un [/] : " cheminUser
    echo $cheminUser
    while [ -z "$cheminUser" ] || [ -d "$cheminUser" ] ; do 
        if [ -z "$cheminUser" ]; then 
            echo -e "Chemin du dossier est vide, Ecrivez un Chemin du dossier correct:">&2
            read -p "   Chemin du dossier en commencant par un /  : " cheminUser
        fi
        if [ -d "$cheminUser" ]; then 
            echo -e "Chemin du dossier exite deja, Ecrivez un Chemin qui n'existe pas :">&2
            read -p "   Chemin du dossier en commencant par un /  : " cheminUser
        fi
    done
    read -p "   Enter a date (yyyy-mm-jj): : " dateinput
    while [ -z "$dateinput" ] || [[ "$dateinput" != [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] ]] || [[ "$(date +%s)" -gt "$(date -d "$dateinput" +%s)" ]]; do 
        if [[ -z "$dateinput" ]]  ; then
            echo -e "Date d'expiration est vide, Ecrivez une date correct:">&2
            read -p "   veuillez tape une date de type (yyyy-mm-jj) : " dateinput
        fi
        if [[ "$dateinput" != [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] ]]  ; then
            echo -e "Date d'expiration non Conforme, Ecrivez une date correct:">&2
            read -p " veuillez tape une date de type (yyyy-mm-jj) : " dateinput
        fi
        if [[ "$(date +%s)" -gt "$(date -d "$dateinput" +%s)" ]]  ; then
            echo -e "Date non conforme date inferieur a aujourd'hui">&2
            read -p " veuillez tape une date de type (yyyy-mm-jj), superieur a aujourd'hui : " dateinput
        fi
    done
    read -p "   Mot de passe de l'utilisateur : " mdpUser
    read -p "   Le Shell l'utilisateur (sh or dash or bash ou autre) : " shellUser
    # First version without install 

    # while [ -z "$shellUser" ] || [ $(ls /bin | grep -E "^$shellUser$" | wc -l) == 0 ]; do 
    #     if [ -z "$shellUser" ];then
    #         echo -e "Le shell est vide, Ecrivez un shell d'utilisateur correct:">&2
    #         read -p "   Shell de l'utilisateur  (sh or dash or bash ou autre ) : " shellUser
    #     else [ $(ls /bin | grep -E "^$shellUser$" | wc -l) == 0 ] 
    #         echo -e "Le shell n'existe pas, Utliser un shell existant ou installer le avant:"
    #         read -p "   Shell de l'utilisateur  (sh or dash or bash ou autre) : " shellUser
    #     fi
    # done

    # Second version with install 
    while [ -z "$shellUser" ] ; do 
        if [ -z "$shellUser" ];then
            echo -e "Le shell est vide, Ecrivez un shell d'utilisateur correct:">&2
            read -p "   Shell de l'utilisateur  (sh or dash or bash ou autre ) : " shellUser
        fi
    done
    while [ true ]; do
        if [ $(ls /bin | grep -E "^$shellUser$" | wc -l) == 0 ] ; then
            sudo apt install $shellUser
        fi
        if [ $(ls /bin | grep -E "^$shellUser$" | wc -l) == 0 ]; then
            echo -e "\nLe shell que vous avez donner n'existe pas, veuillez en donner un autre:">&2
            read -p "   Shell de l'utilisateur : " shellUser
            continue
        fi
        break
    done
    read -p " Identifiant : " idUser
    while [ -z "$idUser" ] || [ $(cat /etc/passwd | grep -E "$idUser" | wc -l) != 0 ]; do 
        if [ -z "$shellUser" ];then
            echo -e "id est vide, Ecrivez un id correct:">&2
            read -p "   Id utilisateur : " idUser
        else [ $(cat /etc/passwd | cut -d ':' -f3 | grep -E "$idUser" | wc -l) != 0 ]
            echo -e "Id est deja specifié a utilisteur UID, veuillez en fournir un autre">&2
            read -p "   Id utilisateur :  " idUser
        fi
    done
    sudo useradd -m -d "$cheminUser" -s "/usr/bin/$shellUser" -e "$dateinput" -p "$mdpUser" -u "$idUser" -G sudo $nameUser
    echo  -e "\n\nSucces l'utilateur a ete creer \n\n"
    displayMenu
}
#**************************************************************#
#                       Display menu Update                                 #
displayUpdate()
{
    echo -e "Update User \n"
    echo -e "Modification:"
    echo -e "\tNom de l'utilisateur : Taper 1"
    echo -e "\tdu chemin de dossier: Taper 2"
    echo -e "\tde la date d'expiration : Taper 3"
    echo -e "\tdu Mot de passe : Taper 4"
    echo -e "\tdu shell: Taper 5"
    echo -e "\tde l'id : Taper 6"
    echo -e "\tRetourner menu : Taper 7"
    echo -e "\tRetourner Quitter : Taper 8\n\n"

    read -p "Quel est la modification a faire ? Taper entre 1 et 8 " valueUpdate
    while [[ "$valueUpdate" != [1-8] ]]  ; do
        read -p " Error: veuillez tape un chiffre entre 1 et 8 :  " valueUpdate
        echo $valueUpdate
    done
    
    if [ $valueUpdate -eq 1 ];then
        updateNameUser 
    fi
    if [ $valueUpdate -eq 2 ];then
        updateCheminUser
    fi
    if [ $valueUpdate -eq 3 ];then
        updateDateExp
    fi
    if [ $valueUpdate -eq 4 ];then
        updateMdp
    fi
    if [ $valueUpdate -eq 5 ];then
        updateShell
    fi
    if [ $valueUpdate -eq 6 ];then
        updateId
    fi
    if [ $valueUpdate -eq 7 ];then
        displayMenu
    fi
    if [ $valueUpdate -eq 8 ];then
        exitMenu
    fi
}

#**************************************************************#
#                       Update USer- Modifie le nom            #
updateNameUser()
{
    read -p "   Veuillez fournir l'ancien Nom de l'utilisateur  : " beforeName
    while [[ $(cat /etc/passwd | grep -E "$beforeName" | wc -l) == 0 ]]; do 
        echo -e "L'utilisateur n'existe pas':">&2
        read -p "   Veuillez donner un utilisateur existant : " beforeName
    done
    read -p "   Veuillez fournir le nouveau Nom de l'utilisateur  : " newName
    while [ -z "$newName" ]; do 
        echo -e "Nom de l'utilisateur est vide, Ecrivez un Nom d'utilisateur correct:">&2
        read -p "   Nom de l'utilisateur : " newName
    done
    sudo usermod -l $newName $beforeName
    echo  -e "\n\nSucces le nom de l'utilsateur  $beforeName a ete modifie par $newName \n\n"
    displayMenu
}
#**************************************************************#
#                       Update chemin du User- Modifie le chemin           #
updateCheminUser()
{
    read -p "   Veuillez fournir le Nom de l'utilisateur que vous voulez modifer : " Name
    while [[ $(cat /etc/passwd | grep -E "$Name" | wc -l) == 0 ]]; do 
        echo -e "L'utilisateur n'existe pas':">&2
        read -p "   Veuillez donner un utilisateur existant : " Name
    done
    read -p "   Veuillez fournir le nouveau chemin : " newChemin
    while [ -z "$newChemin" ] || [ -d "$newChemin" ]; do 
        if [ -z "$newChemin" ]; then 
            echo -e "Chemin du dossier est vide, Ecrivez un Chemin du dossier correct:">&2
            read -p "   Chemin du dossier : " newChemin
        fi
        if [ -d "$newChemin" ]; then 
            echo -e "Chemin du dossier exite deja, Ecrivez un Chemin qui n'existe pas :">&2
            read -p "   Chemin du dossier : " newChemin
        fi
    done
    sudo usermod -m -d $newChemin $Name  
    echo  -e "\n\nSucces le chemin du user a ete $Name a ete modifie par $newChemin \n\n"
    displayMenu
}

#***************************************************************#
# Update date d'expiration du User- Modifie la date experisation#
updateDateExp()
{
    read -p "   Veuillez fournir le Nom de l'utilisateur que vous voulez modifer : " Name
    while [[ $(cat /etc/passwd | grep -E "$Name" | wc -l) == 0 ]]; do 
        echo -e "L'utilisateur n'existe pas':">&2
        read -p "   Veuillez donner un utilisateur existant : " Name
    done
    read -p "   Veuillez fournir la nouvelle date : " newDate
    while [ -z "$newDate" ] || [[ "$newDate" != [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] ]] || [[ "$(date +%s)" -gt "$(date -d "$newDate" +%s)" ]]; do 
        if [[ -z "$newDate" ]]  ; then
            echo -e "Date d'expiration est vide, Ecrivez une date correct:">&2
            read -p "   veuillez tape une date de type (yyyy-mm-jj) : " newDate
        fi
        if [[ "$newDate" != [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] ]]  ; then
            echo -e "Date d'expiration non Conforme, Ecrivez une date correct:">&2
            read -p " veuillez tape une date de type (yyyy-mm-jj) : " newDate
        fi
        if [[ "$(date +%s)" -gt "$(date -d "$newDate" +%s)" ]]  ; then
            echo -e "Date non conforme date inferieur a aujourd'hui">&2
            read -p " veuillez tape une date de type (yyyy-mm-jj), superieur a aujourd'hui : " newDate
        fi
    done
    sudo usermod -e $newDate $Name 
    echo  -e "\n\nSucces la date expiration a ete $Name a ete modifie \n\n"
    displayMenu

}
#***************************************************************#
# Update mot de passe de User- Modifie le mot de passe#
updateMdp()
{
    read -p "   Veuillez fournir le Nom de l'utilisateur que vous voulez modifer : " Name
    while [[ $(cat /etc/passwd | grep -E "$Name" | wc -l) == 0 ]]; do 
        echo -e "L'utilisateur n'existe pas':">&2
        read -p "   Veuillez donner un utilisateur existant : " Name
    done
    sudo passwd $Name 
    echo  -e "\n\nSucces le mot de passe de $Name a ete modifie\n\n"
    displayMenu

}

#***************************************************************#
# Update le shell de User- Modifie le shell#
updateShell()
{
    read -p "   Veuillez fournir le Nom de l'utilisateur que vous voulez modifer : " Name
    while [[ $(cat /etc/passwd | grep -E "$Name" | wc -l) == 0 ]]; do 
        echo -e "L'utilisateur n'existe pas':">&2
        read -p "   Veuillez donner un utilisateur existant : " Name
    done
    read -p "   Le Nouveau Shell de l'utilisateur : " shellUser
    # while [ -z "$shellUser" ] || [ $(ls /bin | grep -E "^$shellUser$" | wc -l) == 0 ]; do 
    #     if [ -z "$shellUser" ];then
    #         echo -e "Le shell est vide, Ecrivez un shell d'utilisateur correct:">&2
    #         read -p "   Shell de l'utilisateur : " shellUser
    #     else [ $(ls /bin | grep -E "^$shellUser$" | wc -l) == 0 ] 
    #         echo -e "Le shell n'existe pas, Utliser un shell existant ou installer le avant:">&2
    #         read -p "   Shell de l'utilisateur : " shellUser
    #     fi
    # done
    while [ -z "$shellUser" ]; do 
        if [ -z "$shellUser" ];then
            echo -e "Le shell est vide, Ecrivez un shell d'utilisateur correct:">&2
            read -p "   Shell de l'utilisateur : " shellUser
        fi
    done
    while [ true ]; do
        if [ $(ls /bin | grep -E "^$shellUser$" | wc -l) == 0 ] ; then
            sudo apt install $shellUser
        fi
        if [ $(ls /bin | grep -E "^$shellUser$" | wc -l) == 0 ]; then
            echo -e "\nLe shell que vous avez donner n'existe pas, veuillez en donner un autre:">&2
            read -p "   Shell de l'utilisateur : " shellUser
            continue
        fi
        break
    done


    sudo usermod -s "/usr/bin/$shellUser" $Name
    echo  -e "\n\nSucces chemin du shell de $Name a ete modifie par /usr/bin/$shellUser \n\n"
    displayMenu
}
#***************************************************************#
# Update l'ID' de User- Modifie Id #
updateId()
{
    read -p "   Veuillez fournir le Nom de l'utilisateur que vous voulez modifer : " Name
    while [[ $(cat /etc/passwd | grep -E "$Name" | wc -l) == 0 ]]; do 
        echo -e "L'utilisateur n'existe pas':">&2
        read -p "   Veuillez donner un utilisateur existant : " Name
    done
    read -p " Donner le nouveau Id du User : " idUser
    while [ -z "$idUser" ]; do 
        echo -e "id est vide, Ecrivez un id correct:">&2
        read -p "   Id utilisateur : " idUser
    done

    sudo usermod -u $idUser $Name
    echo  -e "\n\nSucces id de $Name a ete modifie par $idUser \n\n"
    displayMenu
}
#**************************************************************#
#                       Delete USer                            #
deleteUser()
{
    read -p "   Veuillez fournir le Nom de l'utilisateur que vous voulez modifer : " Name
    while [[ $(cat /etc/passwd | grep -E "$Name" | wc -l) == 0 ]]; do 
        echo -e "L'utilisateur n'existe pas':">&2
        read -p "   Veuillez donner un utilisateur existant : " Name
    done
    read -p " Supprimer le dossier utilisateur [y-n]: " rmDir
    while [[ "$rmDir" != [Y,y,yes,n,N,no] ]] ; do 
        echo -e "Erreur de saisie veuillez saisir :">&2
        read -p " [Y-N] : " rmDir
    done
    read -p " Meme s'il est connecté [y-n]: " rmUserConnected
    while [[ "$rmUserConnected" != [Y,y,yes,n,N,no] ]] ; do 
        echo -e "Error de saisie veuillez  saisir :">&2
        read -p " [Y-N] : " rmUserConnected
    done
    # OUi et NON probleme
    if [[ "$rmDir" == [Y,y,yes] ]] && [[ "$rmUserConnected" == [n,N,no] ]];then
        directory=$(cat /etc/passwd | grep -E $Name | cut -d ':' -f6)
        sudo rm -rf $directory
        sudo userdel $Name
    fi
    # NON et OUI marche
    if [[ "$rmDir" == [n,N,no] ]] && [[ "$rmUserConnected" == [Y,y,yes] ]];then
        sudo killall -u $Name #kill tout les processus en cours
        sudo userdel -f $Name
    fi
    # OUI et OUI probleme
    if [[ "$rmDir" == [Y,y,yes] ]] && [[ "$rmUserConnected" == [Y,y,yes] ]];then
        sudo killall -u $Name #kill tout les processus en cours
        directory=$(cat /etc/passwd | grep -E $Name | cut -d ':' -f6)
        sudo rm -rf $directory
        sudo userdel -f $Name
    fi
    # NON et NON marche
    if [[ "$rmDir" == [n,N,no] ]] && [[ "$rmUserConnected" == [n,N,no] ]];then
        sudo userdel $Name
    fi
    echo  -e "\n\nSucces $Name a ete supprimer \n\n"
    echo  -e "\n\nSucces $Name a ete supprimer \n\n"
    displayMenu
}
########################################################################
####                              MAIN                              ####
########################################################################
verif_options $*
displayMenu
