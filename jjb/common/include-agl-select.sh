# (c) 2016 Jan-Simon Moeller dl9pf(at)gmx.de
# License GPLv2

################################################################################
## Main
################################################################################

HANDLED=false

# Projects in AGL/*
###################
if test !$HANDLED -a $(echo "$TARGETPROJECT" | grep -q "^AGL/"); then

    MYPROJECT=`echo $TARGETPROJECT | sed -e "s#AGL/##g"`

    if test x"AGL-repo" = x"$MYPROJECT" ; then
        cd .repo/manifests
        MYREMOTE=`git remote | head -1`
        git fetch ${MYREMOTE} ${TARGETREFSPEC}
        git reset --hard FETCH_HEAD
        cd ../../
        repo sync --force-sync -d
    else
        if test -n "${GERRIT_CHANGE_NUMBER}" -a -n "${GERRIT_PATCHSET_NUMBER}"  ; then
            repo download $MYPROJECT ${GERRIT_CHANGE_NUMBER}/${GERRIT_PATCHSET_NUMBER}
        else
            cd $MYPROJECT
            MYREMOTE=`git remote | head -1`
            git fetch ${MYREMOTE} ${TARGETREFSPEC}
            git reset --hard FETCH_HEAD
            cd ..
        fi
    fi
    HANDLED=true
fi


# Projects in src/*
###################
if test !$HANDLED -a $(echo "$TARGETPROJECT" | grep -q "^src/"); then

MYPROJECT=`echo $TARGETPROJECT | sed -e "s#src/##g"`

# We need to set the refspec in the recipe. 
# Therefore each src/* must have a .aglrecipe file with the location
# relative to a repo clone
# e.g. ./meta-agl/meta-agl/recipes-graphics/wayland/foo.bb
#
# Also there must be a SRCREV tag which we can manipulate.
#
#
echo "Not implemented"
exit 0

fi


# Projects in staging/*
#######################
if test !$HANDLED -a $(echo "$TARGETPROJECT" | grep -q "^staging/"); then

MYPROJECT=`echo $TARGETPROJECT | sed -e "s#staging/##g"`

# We need to set the refspec in the recipe. 
# Therefore each src/* must have a .aglrecipe file with the location
# relative to a repo clone
# e.g. ./meta-agl/meta-agl/recipes-graphics/wayland/foo.bb
#
# Also there must be a SRCREV tag which we can manipulate.
#
#
echo "Not implemented"
exit 0


fi

if !$HANDLED; then
    echo "COULD NOT SELECT PROJECT, something is wrong!"
    echo "$TARGETPROJECT"
    echo ""
    set
    exit 1
fi

repo manifest -r
repo manifest -r > ../current_default.xml