#!/bin/bash
# mise au point de generer_fonction.sh
# BUG: 001 BUG D IMPORT: en faisant une copie  du bousin et en déplacant tout sauf le repertoire mise au point, 
# il y a eu des problemes d import
# chaine2tableau
set -o nounset
info(){ map="vrai";  [ "$map" = "vrai" ] && echo "[TEST GEN FONC]:$1"; }
racine=$(find ~ -type d -name generer_fonction |head -n 1)


sourcer(){
for f in $(find "$racine" -type f ! -path '*.swp' ! -path '*.git*' ! -path '*.txt'); do
echo "$f"; source "$f"
done 
} 
sourcer 
: <<'DEADCODE'
festdansenv(){
declare -F "$1" 1>&2  2>/dev/null;
}

utility(){
[ $# -eq 1 ] || echo "sourcer/utility chem_fichierasourcer"; exit 1
ch_name="$1"
nom_fich="$(basename $ch_name)"
festdansenv  "${nom_fich}" | info "$nom_fich n est pas dans l environnement" 
source "$f_name" && info "sourcer: ai sourcé $nom_fich"
festdansenv "${nom_fich}" && info "${nom_fich} est dans l environnement"
}


#[ $# -eq 1 ] && utility  "$1"
#if test "$#" = "0"  ; then echo "zero params"; 
while true; do
if read sce; then 
#utility "$sce"
echo "ligne par ligne: $sce"
fi
done < /dev/stdin
#fi
 
}

trouver_fichiers_source(){
for f in $(find "$racine" -type f ! -path '*.swp' ! -path '*.git*' ! -path '*.txt'); do
echo "$f"
done 
}

trouver_fichiers_source |sourcer
DEADCODE

#. ~/bin/generer_fonction/

test_getnbparam(){
resultat_attendu=3
resultat_obtenu=$(getnbparam "," "a,b,c")
assertEquals $resultat_attendu $resultat_obtenu
}




test_spec2fonc(){
resultat_attendu="somme(){ die(){ echo \$\* 1\>\&2 ;  exit 1 } ; [ \$# -ne 2 ] && die \"somme \$1 \$2 \"; main(){ echo \"todo\"; }; main \$@ ;  }"
resultat_obtenu=$(spec2fonc "somme" "1,2")
assertEquals "$resultat_attendu" "$resultat_obtenu"

}

test_renvoyer_skel_fonc(){
resultat_attendu='somme(){ echo " " ; }'
resultat_obtenu=$(renvoyer_skel_fonction "somme")
assertEquals "$resultat_attendu" "$resultat_obtenu"
}


test_spec2test(){
resultat_attendu="test_somme\(\)\{ resultat_attendu=\"3\"\; resultat_obtenu=\"\$( somme 1 2 )\"; assertEquals \"\$resultat_attendu\" \"\$resultat_obtenu\" \}"
resultat_obtenu=$(spec2test "somme" "1,2" "3")
assertEquals "$resultat_attendu" "$resultat_obtenu"
}


test_produire_die(){
resultat_attendu="die(){echo \"\$*\" 1>&2; exit 1;}"
resultat_obtenu="$( produire_die )"
assertEquals "$resultat_attendu" "$resultat_obtenu"
}

test_remplacer_corps(){
resultat_attendu="somme() {alain terrieur} "
resultat_obtenu=$(echo "somme() { pouet } " |remplacer_corps "alain terrieur")
assertEquals "$resultat_attendu" "$resultat_obtenu" 
}

test_produire_placehoders(){
resultat_attendu="PH_1 PH_2 PH_3 PH_4 PH_5 "
resultat_obtenu=$( produire_placeholders "essai autrefonc trois quatre cinq" )
assertEquals "$resultat_attendu" "$resultat_obtenu"
}



test_get_placeholder(){
resultat_attendu="PH_2"
resultat_obtenu=$(get_placeholder 'produire_nbargs' 'produire_die produire_nbargs produire_main_todo produire_main_call')
assertEquals  "$resultat_attendu" "$resultat_obtenu"
}

test_remplacer_placeholder(){
resultat_attendu="essai de placeholder remplacé encore là"
resultat_obtenu=$(echo "essai de placeholder PH_2 encore là" |remplacer_placeholder "PH_2" "remplacé")
assertEquals "$resultat_attendu" "$resultat_obtenu"
}

test_position2mot(){
resultat_attendu="b"
resultat_obtenu=$(position2mot "2" "a b c")
assertEquals "$resultat_attendu" "$resultat_obtenu"
}

test_position(){
resultat_attendu="2"
resultat_obtenu=$(position "b" "a b c")
assertEquals "$resultat_attendu" "$resultat_obtenu"

}


test_prevent_test_from_interpreting_and(){
resultat_attendu="remplacement&pouet"
resultat_obtenu=$( remplacement=$(echo "remplacement&pouet" | prevent_sed_from_interpreting_and);\
echo "PH1" |sed 's/PH1/'"$remplacement"'/;' )
assertEquals "$resultat_attendu"  "$resultat_obtenu"
}


test_produire_nbargs(){
resultat_attendu="[ \$# -ne 5 ] && die  'a5param \$1 \$2 \$3 \$4 \$5';"
resultat_obtenu=$(produire_nbargs  "a,b,c,d,e" "a5param")
assertEquals "$resultat_attendu" "$resultat_obtenu"
}


test_produire_main_todo(){
resultat_attendu="main(){ echo \"todo\";  };"
resutat_obtenu="$(main_todo)"
assertEquals "$resultat_attendu" "$resultat_obtenu"
}


test_produire_main_call(){
resultat_attendu="main \$@ ;"
resultat_obtenu="$(main_call)"
assertEquals "$resultat_attendu" "$resultat_obtenu"
}
. shunit2
