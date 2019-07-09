#!/bin/sh
CMD=$0
if [ x$PROXYDNS = x ]; then
    PROXYDNS=127.0.0.1#5300
fi

if [ x$PROXYRULE = x ]; then
    PROXYRULE=ss_rules_dst_forward_gfwlist
fi

OUT_FILE=

usage() {
    if [ $# -ne 0 ]; then
        echo $1

    fi
    cat << EOF

usage:
  $CMD [option|-o,-d,-r]

  option:
    -o : output stream, default  stdout
    -d : dns forward, default  127.0.0.1#5300
    -r : proxy redirect rule , default ss_rules_dst_forward_gfwlist

EOF

    exit $2
}

parse_parameter() {

    while true; do
        if [ x$1 = x ]; then
            break
        fi

        ## output file
        if [ $1 = '-o' ]; then
            shift
            if [ x$1 = x ]; then
                usage "option [-o] required  a  parameter" 2 >&2

            else
                OUT_FILE=$1
                shift
                continue
            fi
        fi

        ## dns

        if [ $1 = '-d' ]; then
            shift
            if [ x$1 = x ]; then
                usage "option [-d] required  a  parameter" 2 >&2

            else
                PROXYDNS=$1
                shift
                continue
            fi
        fi

        ##forward rule
        if [ $1 = '-r' ]; then
            shift
            if [ x$1 = x ]; then
                usage "option [-r] required  a  parameter" 2 >&2
            else
                PROXYRULE=$1
                shift
                continue
            fi
        fi
    done

}

genitem() {
    for line in $(cat speedlist.txt); do

        echo server=/$line/$PROXYDNS
        echo ipset=/$line/$PROXYRULE
        echo
    done
}
generate_rule(){
    if [ x$OUT_FILE = x ];then
    genitem
    else
    genitem > $OUT_FILE
    fi
}
parse_parameter $*
generate_rule

