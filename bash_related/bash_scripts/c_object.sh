c_object() {
    # I will see this mess alot likely
    if [[ $# -eq 0 ]] ; then
            echo "Usage: c_object object_name"
    else
        # Make all the files
        mkdir -p src/$1/include
        touch src/$1/$1.c
        touch src/$1/include/$1.h

        # Put the include in the C file
        echo "#include\"${1}\"" > src/$1/$1.c

        # Get the first three letters of the object
        tmp=${1:0:3}
        # Put the gaurd on the header
        echo "#ifndef ${tmp^}_H" > src/$1/include/$1.h
        echo "#define ${tmp^}_H" >> src/$1/include/$1.h
        echo "#endif" >> src/$1/include/$1.h
    fi
}
