_ws="$(builtin cd "`dirname "${BASH_SOURCE[0]}"`" > /dev/null && pwd)"

clean () {
    echo "Removing $1"
    rm -rf install/$1 build/$1
}
case $@ in
    "")
    ;;&
    px4)
        echo "Deleting packages related to PX4 and cleaning PX4 builds folder..."
        _deleted_pkgs=""
        cd $_ws/src/PX4-Autopilot
        make clean
    ;;
    *)
        _deleted_pkgs="$@"
    ;;
esac
cd $_ws
if [ -z "$1" ]; then
    echo "Removing install/ build/ log/"
    rm -rf install/ build/ log/
else
    for val in $_deleted_pkgs; do
        clean $val
        if [ "$val" = "px4_ros_com" ]; then
            rm src/$val/src/micrortps_agent/RtpsTopics.*
        fi
    done
fi
