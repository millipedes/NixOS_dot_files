latex_project() {
    # I will see this mess alot likely
    if [[ $# -lt 3 ]] ; then
            echo -e "Useage:\n|->> latex_project file_name project_name class"
    else
        # Makefile Stuff
        touch Makefile
        echo "all:" > Makefile
        echo -e "\tpdflatex ${1}.tex" >> Makefile
        echo -e "\trm *.log *.aux" >> Makefile
        echo -e "\tclear" >> Makefile
        echo -e "\tclear\n" >> Makefile
        echo -e "open:" >> Makefile
        echo -e "\tevince ${1}.pdf&" >> Makefile
        echo -e " vim:" >> Makefile
        echo -e "\tnvim ${1}.tex" >> Makefile

        # Replace Project Name and Class Name
        cp ~/.config/bash_scripts/references/general.tex ./$1.tex
        sed -i "s/PPRROOJJEECCTT/$2/g" $1.tex
        sed -i "s/CCLLAASS/$3/g" $1.tex
    fi
}
