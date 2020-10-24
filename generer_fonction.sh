#!/bin/bash
die() { echo "$*" 1>&2 ; exit 1; }
mise_au_point() { map="vrai";  [ "$map" = "vrai" ] && echo $1; }
generer_fonction(){

usage(){
echo "generer_fonction nom_fonc espace params_separes_par_virgules espace result_attendu -> squelette fonction et squelette test" 
}
# nbargs or die
[ $# -ne 3 ] && usage; exit 1
# init vars
NOM_FONC="$1"; PARAMETRES_NON_SEPARES="$2"; RESULTAT="$3"
# includes
for f in ./$(basename $0 .sh); do declare -F $f || source $f; mise_au_point "[GENERER_FONCTION] : sourcing $f"; done
# main
main(){
cree_fichier_vide  "$NOM_FONC"
spec2fonc "$NOM_FONC" "$PARAMETRES_NON_SEPARES" >> "$NOM_FONC"
spec2test "$NOM_FONC" "$PARAMETRES_NON_SEPARES" "$RESULTAT" >> "$NOM_FONC"
}

main


}



