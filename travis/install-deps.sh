set -e
set -x

TRAVIS_ROOT="$1"
PRK_TARGET="$2"

# eventually make this runtime configurable
MPI_LIBRARY=mpich

case "$PRK_TARGET" in
    allserial)
        echo "Serial"
        ;;

    allopenmp)
        echo "OpenMP"
        ;;
    allmpi*)
        echo "Any normal MPI"
        sh ./travis/install-mpi.sh $TRAVIS_ROOT $MPI_LIBRARY
        ;;
    allshmem)
        echo "SHMEM"
        sh ./travis/install-libfabric.sh $TRAVIS_ROOT
        sh ./travis/install-sandia-openshmem.sh $TRAVIS_ROOT
        ;;
    allupc)
        echo "UPC"
        case "$UPC_IMPL" in
            gupc)
                # GUPC is working fine
                sh ./travis/install-intrepid-upc.sh $TRAVIS_ROOT
                ;;
            bupc)
                # BUPC is new
                sh ./travis/install-berkeley-upc.sh $TRAVIS_ROOT upd # conduit
                ;;
            *)
                echo "Apparently UPC_IMPL was not exported properly"
                echo "UPC_IMPL=$UPC_IMPL"
                exit 5
                ;;
        esac
        ;;
    allcharm++)
        echo "Charm++"
        sh ./travis/install-charm++.sh $TRAVIS_ROOT charm++
        ;;
    allampi)
        echo "Adaptive MPI (AMPI)"
        sh ./travis/install-charm++.sh $TRAVIS_ROOT AMPI
        ;;
    allfgmpi)
        echo "Fine-Grain MPI (FG-MPI)"
        sh ./travis/install-fgmpi.sh $TRAVIS_ROOT
        ;;
    allgrappa)
        echo "Grappa"
        case "$CC" in
            gcc)
                # test for version - only install if required
                #sh ./travis/install-gcc.sh $TRAVIS_ROOT
                ;;
            clang)
                # test for version - only install if required
                #sh ./travis/install-clang.sh $TRAVIS_ROOT
                ;;
        esac
        sh ./travis/install-cmake.sh $TRAVIS_ROOT
        sh ./travis/install-mpi.sh $TRAVIS_ROOT mpich
        sh ./travis/install-grappa.sh $TRAVIS_ROOT mpich
        ;;
esac
