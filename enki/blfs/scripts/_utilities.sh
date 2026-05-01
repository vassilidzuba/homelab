
source $SCRIPT_DIR/_params.sh

check_flag ()  {
    FLAG=$FLAGDIR/$PACKAGE
    if [ -f "$FLAG" ]; then
        echo "Package $PACKAGE is already built."
        exit 255
    fi
}

check_archive () {
    if [ ! -f $SRCDIR/$SOURCE ]; then
        if [ -f $SHAREDDIR/$SOURCE ]; then
            echo copying $SOURCE from shared $SCRIPT_DIR
            cp $SHAREDDIR/$SOURCE $SRCDIR
            if [ $? != 0 ]; then
                echo failure when copying the file $SOURCE
                exit 255
            fi
        else
            if [ "$URL" != "" ]; then
                echo "Downloading $URL"
                pushd $SRCDIR
                wget -O "$SOURCE" "$URL"
                if [ "$MD5" != "" ]; then
                    if [ "$(md5sum $SOURCE)" != "$MD5  $SOURCE" ]; then
                        echo "BAD CHECKSUM : $SRC"
                        exit 255
                    fi
                fi
                popd
            else
                echo "not available in shared directory: $SOURCE"
                exit 255
            fi
        fi
    fi
}

expand_archive () {
    cd $SRCDIR

    if [ ! -d $PACKAGE ]; then
        tar xvf $SOURCE
        if [ $? -eq 1 ]; then
            echo "unable to extract archive"
            exit 255
        fi
    fi

    cd $PACKAGE
}

run_prolog () {
    check_flag
    check_archive
    expand_archive
}

run_cleanup () {
    touch $FLAG
    cd $SRCDIR
    rm -rf $PACKAGE
}

run_all () {
    if [[ $(type -t run_build) != function ]]; then
        echo function run_build missing
        exit 255
    fi
    if [[ $(type -t run_install) != function ]]; then
        echo function run_install missing
        exit 255
    fi

    run_prolog

    run_build
    if [ "$?" != 0 ]; then
        echo "Build of $PACKAGE failed"
        exit 255
    fi

    if [[ $(type -t run_test) == function ]]; then
        run_test
        if [ "$?" != 0 ]; then
            echo "Test of $PACKAGE failed"
            exit 255
        fi
    fi

    run_install
    if [ "$?" != 0 ]; then
        echo "Install of $PACKAGE failed"
        exit 255
    fi
    run_cleanup
}
